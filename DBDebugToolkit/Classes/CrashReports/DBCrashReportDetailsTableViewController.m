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

typedef NS_ENUM(NSUInteger, DBCrashReportDetailsTableViewControllerSection) {
    DBCrashReportDetailsTableViewControllerSectionDetails,
    DBCrashReportDetailsTableViewControllerSectionContext,
    DBCrashReportDetailsTableViewControllerSectionUserInfo,
    DBCrashReportDetailsTableViewControllerSectionStackTrace
};

static NSString *const DBCrashReportDetailsTableViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";
static NSString *const DBCrashReportDetailsTableViewControllerContextCellIdentifier = @"ContextCell";
static NSString *const DBCrashReportDetailsTableViewControllerStackTraceCellIdentifier = @"StackTraceCell";

@interface DBCrashReportDetailsTableViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *shareButton;
@property (nonatomic, strong) NSArray <DBTitleValueTableViewCellDataSource *> *detailCellDataSources;
@property (nonatomic, strong) NSArray <DBTitleValueTableViewCellDataSource *> *userInfoCellDataSources;

@end

@implementation DBCrashReportDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDetailCellDataSources];
    [self setupUserInfoCellDataSources];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTitleValueTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBCrashReportDetailsTableViewControllerTitleValueCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}

#pragma mark - Share button

- (IBAction)shareButtonAction:(id)sender {
    
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
            }
            contextCell.textLabel.text = indexPath.row == 0 ? @"Screenshot" : @"Console output";
            contextCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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

#pragma mark - Private methods

#pragma mark - - Detail cells

- (void)setupDetailCellDataSources {
    NSMutableArray *detailCellDataSources = [NSMutableArray array];
    [detailCellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Name"
                                                                                        value:self.crashReport.name]];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:self.crashReport.date
                                                          dateStyle:NSDateFormatterMediumStyle
                                                          timeStyle:NSDateFormatterMediumStyle];
    [detailCellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Date"
                                                                                        value:dateString]];
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
    [imageViewViewController configureWithTitle:@"Screenshot" image:self.crashReport.screenshot];
    [self.navigationController pushViewController:imageViewViewController animated:YES];
}

- (void)openConsoleOutputPreview {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBTextViewViewController" bundle:bundle];
    DBTextViewViewController *textViewViewController = [storyboard instantiateInitialViewController];
    [textViewViewController configureWithTitle:@"Console output" text:self.crashReport.consoleOutput];
    [self.navigationController pushViewController:textViewViewController animated:YES];
}

@end
