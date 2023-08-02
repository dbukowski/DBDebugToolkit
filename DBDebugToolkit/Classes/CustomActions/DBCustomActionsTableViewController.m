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

#import "DBCustomActionsTableViewController.h"
#import "UILabel+DBDebugToolkit.h"

static NSString *const DBCustomActionsTableViewControllerButtonCellIdentifier = @"DBMenuButtonTableViewCell";

@interface DBCustomActionsTableViewController ()

@property (nonatomic, strong) UILabel *backgroundLabel;

@end

@implementation DBCustomActionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self setupBackgroundLabel];
}

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBCustomAction *action = self.customActions[indexPath.row];
    [action perform];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfItems = self.customActions.count;
    self.backgroundLabel.text = numberOfItems == 0 ? @"There are no custom actions." : @"";
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBCustomAction *action = self.customActions[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DBCustomActionsTableViewControllerButtonCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:DBCustomActionsTableViewControllerButtonCellIdentifier];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.textLabel.textColor = cell.tintColor;
    }
    cell.textLabel.text = action.name;
    return cell;
}

@end
