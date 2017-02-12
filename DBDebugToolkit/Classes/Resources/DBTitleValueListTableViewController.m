//
//  DBTitleValueListTableViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 12.02.2017.
//
//

#import "DBTitleValueListTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBTitleValueTableViewCell.h"

static NSString *const DBTitleValueListTableViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";

@interface DBTitleValueListTableViewController ()

@property (nonatomic, strong) UILabel *backgroundLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;

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
    self.backgroundLabel = [[UILabel alloc] init];
    self.backgroundLabel.textColor = [UIColor darkGrayColor];
    self.backgroundLabel.textAlignment = NSTextAlignmentCenter;
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
