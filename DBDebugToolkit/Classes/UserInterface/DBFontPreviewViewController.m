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

#import "DBFontPreviewViewController.h"

static const NSUInteger DBFontPreviewViewControllerFontSize = 12;

@interface DBFontPreviewViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIButton *previousButton;
@property (nonatomic, weak) IBOutlet UIButton *nextButton;
@property (nonatomic, weak) IBOutlet UILabel *familyNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fontNameLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *separatorViewHeightConstraint;
@property (nonatomic, assign) NSInteger selectedFontIndex;
@property (nonatomic, copy) NSArray <NSString *> *allFontNames;

@end

@implementation DBFontPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.separatorViewHeightConstraint.constant = 1.0 / [UIScreen mainScreen].scale;
    self.textView.text = [self exampleText];
    [self refreshView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.textView.contentOffset = CGPointZero;
}

#pragma mark - Navigation

- (IBAction)previousButtonAction:(id)sender {
    self.selectedFontIndex -= 1;
    [self refreshView];
}

- (IBAction)nextButtonAction:(id)sender {
    self.selectedFontIndex += 1;
    [self refreshView];
}

#pragma mark - Configuration

- (void)configureWithSelectedFontIndex:(NSInteger)selectedFontIndex allFontNames:(NSArray <NSString *> *)allFontNames {
    self.selectedFontIndex = selectedFontIndex;
    self.allFontNames = allFontNames;
}

#pragma mark - Private methods

- (void)refreshView {
    NSString *selectedFontName = self.allFontNames[self.selectedFontIndex];
    self.textView.font = [UIFont fontWithName:selectedFontName size:DBFontPreviewViewControllerFontSize];
    self.fontNameLabel.text = selectedFontName;
    self.familyNameLabel.text = self.textView.font.familyName;
    self.previousButton.enabled = self.selectedFontIndex > 0;
    self.nextButton.enabled = self.selectedFontIndex < self.allFontNames.count - 1;
}

- (NSString *)exampleText {
    return @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?\n\nAt vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.";
}

@end
