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

#import "DBCrashReportsTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBTitleValueTableViewCell.h"
#import "UILabel+DBDebugToolkit.h"
#import "DBCrashReportDetailsTableViewController.h"
#import "DBBuildInfoProvider.h"
#import "DBDeviceInfoProvider.h"

static NSString *const DBCrashReportsTableViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";

@interface DBCrashReportsTableViewController ()

@property (nonatomic, strong) UILabel *backgroundLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *clearButton;

@end

@implementation DBCrashReportsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTitleValueTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBCrashReportsTableViewControllerTitleValueCellIdentifier];
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
    [self.crashReportsToolkit clearCrashReports];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBCrashReport *crashReport = self.crashReportsToolkit.crashReports[indexPath.row];
    [self openCrashReportDetailsWithCrashReport:crashReport];
}

- (void)openCrashReportDetailsWithCrashReport:(DBCrashReport *)crashReport {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBCrashReportDetailsTableViewController" bundle:bundle];
    DBCrashReportDetailsTableViewController *crashReportDetailsViewController = [storyboard instantiateInitialViewController];
    crashReportDetailsViewController.crashReport = crashReport;
    crashReportDetailsViewController.deviceInfoProvider = [DBDeviceInfoProvider new];
    crashReportDetailsViewController.buildInfoProvider = [DBBuildInfoProvider new];
    [self.navigationController pushViewController:crashReportDetailsViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.crashReportsToolkit.isCrashReportingEnabled) {
        self.backgroundLabel.text = @"Crash reporting disabled.";
        self.clearButton.enabled = NO;
        return 0;
    }
    NSInteger numberOfItems = self.crashReportsToolkit.crashReports.count;
    self.backgroundLabel.text = numberOfItems == 0 ? @"There are no crash reports." : @"";
    self.clearButton.enabled = numberOfItems > 0;
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBTitleValueTableViewCell *titleValueCell = [self.tableView dequeueReusableCellWithIdentifier:DBCrashReportsTableViewControllerTitleValueCellIdentifier];
    DBTitleValueTableViewCellDataSource *dataSource = [self dataSourceForCellAtRow:indexPath.row];
    [titleValueCell configureWithDataSource:dataSource];
    [titleValueCell setSeparatorInset:UIEdgeInsetsZero];
    [titleValueCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return titleValueCell;
}

#pragma mark - Private methods

- (DBTitleValueTableViewCellDataSource *)dataSourceForCellAtRow:(NSInteger)row {
    DBCrashReport *crashReport = self.crashReportsToolkit.crashReports[row];
    return [DBTitleValueTableViewCellDataSource dataSourceWithTitle:crashReport.name
                                                              value:crashReport.dateString];
}

@end
