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

#import "DBTitleValueListTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBTitleValueTableViewCell.h"
#import "UILabel+DBDebugToolkit.h"

static NSString *const DBTitleValueListTableViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";

@interface DBTitleValueListTableViewController ()

@property (nonatomic, strong) UILabel *backgroundLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *clearButton;

@end

@implementation DBTitleValueListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.viewModel viewTitle];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTitleValueTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBTitleValueListTableViewControllerTitleValueCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.tableFooterView = [UIView new];
    [self setupBackgroundLabel];
}

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
}

#pragma mark - Clear button

- (IBAction)clearButtonAction:(id)sender {
    [self.viewModel handleClearAction];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfItems = [self.viewModel numberOfItems];
    self.backgroundLabel.text = numberOfItems == 0 ? [self.viewModel emptyListDescriptionString] : @"";
    self.clearButton.enabled = numberOfItems > 0;
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBTitleValueTableViewCell *titleValueCell = [self.tableView dequeueReusableCellWithIdentifier:DBTitleValueListTableViewControllerTitleValueCellIdentifier];
    DBTitleValueTableViewCellDataSource *dataSource = [self.viewModel dataSourceForItemAtIndex:indexPath.row];
    [titleValueCell configureWithDataSource:dataSource];
    [titleValueCell setSeparatorInset:UIEdgeInsetsZero];
    return titleValueCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.viewModel handleDeleteItemActionAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
