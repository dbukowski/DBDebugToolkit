//
//  DBCookieDetailsTableViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 12.02.2017.
//
//

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
    [titleValueCell setSeparatorInset:UIEdgeInsetsZero];
    return titleValueCell;
}


@end
