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

#import "DBCookieDetailsTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBTitleValueTableViewCell.h"

static NSString *const DBCookieDetailsTableViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";

@interface DBCookieDetailsTableViewController ()

@property (nonatomic, strong) NSArray *cellDataSources;

@end

@implementation DBCookieDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTitleValueTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBCookieDetailsTableViewControllerTitleValueCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.tableFooterView = [UIView new];
    [self setupCellDataSources];
}

- (IBAction)deleteButtonAction:(id)sender {
    [self.delegate cookieDetailsTableViewController:self didTapDeleteWithCookie:self.cookie];
}

#pragma mark - Cell data sources

- (void)setupCellDataSources {
    NSMutableArray *cellDataSources = [NSMutableArray array];
    NSDictionary *cookieProperties = [self.cookie properties];
    for (NSString *key in cookieProperties.allKeys) {
        NSString *value = [NSString stringWithFormat:@"%@", cookieProperties[key]];
        [cellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:key
                                                                                      value:value]];
    }
    [cellDataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Session only"
                                                                                  value:self.cookie.sessionOnly ? @"TRUE" : @"FALSE"]];
    [cellDataSources sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [[obj1 title] compare:[obj2 title]];
    }];
    
    self.cellDataSources = [cellDataSources copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDataSources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBTitleValueTableViewCell *titleValueCell = [self.tableView dequeueReusableCellWithIdentifier:DBCookieDetailsTableViewControllerTitleValueCellIdentifier];
    DBTitleValueTableViewCellDataSource *dataSource = self.cellDataSources[indexPath.row];
    [titleValueCell configureWithDataSource:dataSource];
    
    return titleValueCell;
}


@end
