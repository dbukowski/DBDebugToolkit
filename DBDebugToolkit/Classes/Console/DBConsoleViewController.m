// The MIT License
//
// Copyright (c) 2016 Dariusz Bukowski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DBConsoleViewController.h"
#import <MessageUI/MessageUI.h>

@interface DBConsoleViewController () <DBConsoleOutputCaptorDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *clearBarButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *sendBarButtonItem;
@property (nonatomic, strong) MFMailComposeViewController *mailComposeViewController;

@end

@implementation DBConsoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.consoleOutputCaptor.delegate = self;
    [self reloadConsole];
    [self updateShowingConsole];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self scrollToBottom];
}

- (void)dealloc {
    [self.mailComposeViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadConsole {
    CGSize contentSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, DBL_MAX)];
    BOOL shouldScrollToBottom = -self.textView.contentOffset.y + contentSize.height <= self.textView.frame.size.height + DBL_EPSILON;
    self.textView.text = self.consoleOutputCaptor.consoleOutput;
    if (shouldScrollToBottom) {
        [self scrollToBottom];
    }
}

- (void)scrollToBottom {
    CGSize contentSize = [self.textView sizeThatFits:CGSizeMake(self.textView.frame.size.width, DBL_MAX)];
    self.textView.contentOffset = CGPointMake(0, MAX(contentSize.height - self.textView.frame.size.height, 0));
}

- (void)updateShowingConsole {
    self.clearBarButtonItem.enabled = self.consoleOutputCaptor.enabled;
    self.sendBarButtonItem.enabled = self.consoleOutputCaptor.enabled && [MFMailComposeViewController canSendMail];
    self.textView.hidden = !self.consoleOutputCaptor.enabled;
}

#pragma mark - Sending logs

- (IBAction)sendButtonAction:(id)sender {
    self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
    self.mailComposeViewController.mailComposeDelegate = self;
    [self.mailComposeViewController setSubject:[self consoleOutputMailSubject]];
    [self.mailComposeViewController setMessageBody:[self consoleOutputMailHTMLBody] isHTML:YES];
    
    [self presentViewController:self.mailComposeViewController animated:YES completion:NULL];
}

- (NSString *)consoleOutputMailSubject {
    return [NSString stringWithFormat:@"%@ - console output", [self.buildInfoProvider buildInfoString]];
}

- (NSString *)consoleOutputMailHTMLBody {
    NSMutableString *mailHTMLBody = [NSMutableString string];
    
    // Device model.
    [mailHTMLBody appendFormat:@"<b>Device model:</b> %@<br/>", [self.deviceInfoProvider deviceModel]];
    
    // System version.
    [mailHTMLBody appendFormat:@"<b>System version:</b> %@", [self.deviceInfoProvider systemVersion]];
    
    // Console output.
    NSString *consoleOutputWithIgnoredHTMLTags = [self.textView.text stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
    NSString *consoleOutputWithProperNewlines = [consoleOutputWithIgnoredHTMLTags stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    [mailHTMLBody appendFormat:@"<p><b>Console output:</b><br>%@</p>", consoleOutputWithProperNewlines];
    
    return mailHTMLBody;
}

#pragma mark - Clearing console

- (IBAction)clearButtonAction:(id)sender {
    [self.consoleOutputCaptor clearConsoleOutput];
}

#pragma mark - DBConsoleOutputCaptorDelegate 

- (void)consoleOutputCaptorDidUpdateOutput:(DBConsoleOutputCaptor *)consoleOutputCaptor {
    [self reloadConsole];
}

- (void)consoleOutputCaptor:(DBConsoleOutputCaptor *)consoleOutputCaptor didSetEnabled:(BOOL)enabled {
    [self updateShowingConsole];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
