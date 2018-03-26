// The MIT License
//
// Copyright (c) 2017 Dariusz Bukowski
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

#import "DBCrashReportDetailsTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBTitleValueTableViewCell.h"
#import "DBTextViewViewController.h"
#import "DBImageViewViewController.h"
#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSUInteger, DBCrashReportDetailsTableViewControllerSection) {
    DBCrashReportDetailsTableViewControllerSectionDetails,
    DBCrashReportDetailsTableViewControllerSectionContext,
    DBCrashReportDetailsTableViewControllerSectionUserInfo,
    DBCrashReportDetailsTableViewControllerSectionStackTrace
};

static NSString *const DBCrashReportDetailsTableViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";
static NSString *const DBCrashReportDetailsTableViewControllerContextCellIdentifier = @"ContextCell";
static NSString *const DBCrashReportDetailsTableViewControllerStackTraceCellIdentifier = @"StackTraceCell";

@interface DBCrashReportDetailsTableViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property (nonatomic, strong) NSArray <DBTitleValueTableViewCellDataSource *> *detailCellDataSources;
@property (nonatomic, strong) NSArray <DBTitleValueTableViewCellDataSource *> *userInfoCellDataSources;
@property (nonatomic, strong) MFMailComposeViewController *mailComposeViewController;

@end

@implementation DBCrashReportDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDetailCellDataSources];
    [self setupUserInfoCellDataSources];
    [self setupShareButton];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTitleValueTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBCrashReportDetailsTableViewControllerTitleValueCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}

- (void)dealloc {
    [self.mailComposeViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Share button

- (void)setupShareButton {
    self.shareButton.enabled = [MFMailComposeViewController canSendMail];
}

- (IBAction)shareButtonAction:(id)sender {
    self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
    self.mailComposeViewController.mailComposeDelegate = self;
    [self.mailComposeViewController setSubject:[self mailSubject]];
    [self.mailComposeViewController setMessageBody:[self mailHTMLBody] isHTML:YES];

    if (self.crashReport.screenshot) {
        NSData *screenshotData = UIImageJPEGRepresentation(self.crashReport.screenshot, 1);
        [self.mailComposeViewController addAttachmentData:screenshotData mimeType:@"image/jpeg" fileName:@"screenshot"];
    }

    [self presentViewController:self.mailComposeViewController animated:YES completion:NULL];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DBCrashReportDetailsTableViewControllerSectionDetails:
            return self.detailCellDataSources.count;
        case DBCrashReportDetailsTableViewControllerSectionContext:
            return 2;
        case DBCrashReportDetailsTableViewControllerSectionUserInfo:
            return self.crashReport.userInfo.count;
        case DBCrashReportDetailsTableViewControllerSectionStackTrace:
            return self.crashReport.callStackSymbols.count;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }
    
    switch (section) {
        case DBCrashReportDetailsTableViewControllerSectionDetails:
            return @"Details";
        case DBCrashReportDetailsTableViewControllerSectionContext:
            return @"Context";
        case DBCrashReportDetailsTableViewControllerSectionUserInfo:
            return @"User info";
        case DBCrashReportDetailsTableViewControllerSectionStackTrace:
            return @"Stack trace";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case DBCrashReportDetailsTableViewControllerSectionDetails: {
            DBTitleValueTableViewCell *titleValueCell = [self.tableView dequeueReusableCellWithIdentifier:DBCrashReportDetailsTableViewControllerTitleValueCellIdentifier];
            DBTitleValueTableViewCellDataSource *dataSource = self.detailCellDataSources[indexPath.row];
            [titleValueCell configureWithDataSource:dataSource];
            [titleValueCell setSeparatorInset:UIEdgeInsetsZero];
            return titleValueCell;
        }
        case DBCrashReportDetailsTableViewControllerSectionContext: {
            UITableViewCell *contextCell = [tableView dequeueReusableCellWithIdentifier:DBCrashReportDetailsTableViewControllerContextCellIdentifier];
            if (contextCell == nil) {
                contextCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:DBCrashReportDetailsTableViewControllerContextCellIdentifier];
                contextCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            contextCell.textLabel.text = indexPath.row == 0 ? @"Screenshot" : @"Console output";
            return contextCell;
        }
        case DBCrashReportDetailsTableViewControllerSectionUserInfo: {
            DBTitleValueTableViewCell *titleValueCell = [self.tableView dequeueReusableCellWithIdentifier:DBCrashReportDetailsTableViewControllerTitleValueCellIdentifier];
            DBTitleValueTableViewCellDataSource *dataSource = self.userInfoCellDataSources[indexPath.row];
            [titleValueCell configureWithDataSource:dataSource];
            [titleValueCell setSeparatorInset:UIEdgeInsetsZero];
            return titleValueCell;
        }
        case DBCrashReportDetailsTableViewControllerSectionStackTrace: {
            UITableViewCell *stackTraceCell = [tableView dequeueReusableCellWithIdentifier:DBCrashReportDetailsTableViewControllerStackTraceCellIdentifier];
            if (stackTraceCell == nil) {
                stackTraceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                        reuseIdentifier:DBCrashReportDetailsTableViewControllerStackTraceCellIdentifier];
                stackTraceCell.textLabel.numberOfLines = 0;
                stackTraceCell.textLabel.font = [UIFont systemFontOfSize:12];
                stackTraceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            stackTraceCell.textLabel.text = self.crashReport.callStackSymbols[indexPath.row];
            return stackTraceCell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != DBCrashReportDetailsTableViewControllerSectionContext) {
        return;
    }
    
    if (indexPath.row == 0) {
        [self openScreenshotPreview];
    } else {
        [self openConsoleOutputPreview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private methods

#pragma mark - - Detail cells

- (void)setupDetailCellDataSources {
    NSMutableArray *detailCellDataSources = [NSMutableArray array];
    [detailCellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Name"
                                                                                        value:self.crashReport.name]];
    [detailCellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Date"
                                                                                        value:self.crashReport.dateString]];
    if (self.crashReport.reason) {
        [detailCellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Reason"
                                                                                            value:self.crashReport.reason]];
    }
    [detailCellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"App version"
                                                                                        value:self.crashReport.appVersion]];
    [detailCellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"System version"
                                                                                        value:self.crashReport.systemVersion]];
    self.detailCellDataSources = [detailCellDataSources copy];
}

#pragma mark - - User info cells

- (void)setupUserInfoCellDataSources {
    NSMutableArray *userInfoCellDataSources = [NSMutableArray array];
    for (NSString *key in self.crashReport.userInfo.allKeys) {
        NSString *value = [NSString stringWithFormat:@"%@", self.crashReport.userInfo[key]];
        DBTitleValueTableViewCellDataSource *dataSource = [DBTitleValueTableViewCellDataSource dataSourceWithTitle:key
                                                                                                             value:value];
        [userInfoCellDataSources addObject:dataSource];
    }
    self.userInfoCellDataSources = [userInfoCellDataSources copy];
}

#pragma mark - - Section heights

- (CGFloat)heightForFooterAndHeaderInSection:(NSInteger)section {
    return [self tableView:self.tableView numberOfRowsInSection:section] > 0 ? UITableViewAutomaticDimension : CGFLOAT_MIN;
}

#pragma mark - - Opening context screens

- (void)openScreenshotPreview {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBImageViewViewController" bundle:bundle];
    DBImageViewViewController *imageViewViewController = [storyboard instantiateInitialViewController];
    [imageViewViewController configureWithTitle:@"Screenshot"
                                          image:self.crashReport.screenshot
                                placeholderText:@"No screenshot available."];
    [self.navigationController pushViewController:imageViewViewController animated:YES];
}

- (void)openConsoleOutputPreview {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBTextViewViewController" bundle:bundle];
    DBTextViewViewController *textViewViewController = [storyboard instantiateInitialViewController];
    [textViewViewController configureWithTitle:@"Console output" text:self.crashReport.consoleOutput isInConsoleMode:YES];
    [self.navigationController pushViewController:textViewViewController animated:YES];
}

#pragma mark - - Email content


- (NSString *)mailSubject {
    return [NSString stringWithFormat:@"%@ - Crash report: %@, %@", [self.buildInfoProvider buildInfoString],
                                                                    self.crashReport.name,
                                                                    self.crashReport.dateString];
}

- (NSString *)mailHTMLBody {
    NSMutableString *mailHTMLBody = [NSMutableString string];

    // Environment.
    [mailHTMLBody appendString:@"<b><u>Environment:</u></b><br/>"];

    // App version.
    [mailHTMLBody appendFormat:@"<b>App version:</b> %@<br/>", [self.buildInfoProvider buildInfoString]];

    // System version.
    [mailHTMLBody appendFormat:@"<b>System version:</b> %@<br/>", [self.deviceInfoProvider systemVersion]];

    // Device model.
    [mailHTMLBody appendFormat:@"<b>Device model:</b> %@<br/><br/>", [self.deviceInfoProvider deviceModel]];


    // Details.
    [mailHTMLBody appendString:@"<b><u>Details:</u></b><br/>"];

    // Name.
    [mailHTMLBody appendFormat:@"<b>Name:</b> %@<br/>", self.crashReport.name];

    // Date.
    [mailHTMLBody appendFormat:@"<b>Date:</b> %@<br/>", self.crashReport.dateString];

    // Reason.
    if (self.crashReport.reason) {
        [mailHTMLBody appendFormat:@"<b>Reason:</b> %@<br/>", self.crashReport.reason];
    }


    // User info.
    if (self.crashReport.userInfo.count > 0) {
        [mailHTMLBody appendString:@"<br/><b><u>User info:</u></b><br/>"];
        for (NSString *key in self.crashReport.userInfo.allKeys) {
            NSString *value = self.crashReport.userInfo[key];
            [mailHTMLBody appendFormat:@"<b>%@:</b> %@<br/>", key, value];
        }
    }


    // Stack trace.
    NSString *stackTrace = [self.crashReport.callStackSymbols componentsJoinedByString:@"\n"];
    NSString *stackTraceWithIgnoredHTMLTags = [stackTrace stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
    NSString *stackTraceWithProperNewlines = [stackTraceWithIgnoredHTMLTags stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    [mailHTMLBody appendFormat:@"<p><b><u>Stack trace:</u></b><br>%@</p>", stackTraceWithProperNewlines];

    // Console output.
    NSString *consoleOutputWithIgnoredHTMLTags = [self.crashReport.consoleOutput stringByReplacingOccurrencesOfString:@"<" withString:@"&lt"];
    NSString *consoleOutputWithProperNewlines = [consoleOutputWithIgnoredHTMLTags stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    [mailHTMLBody appendFormat:@"<p><b><u>Console output:</u></b><br>%@</p>", consoleOutputWithProperNewlines];

    return mailHTMLBody;
}

@end
