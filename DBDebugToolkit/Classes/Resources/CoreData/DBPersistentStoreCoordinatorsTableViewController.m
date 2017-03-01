//
//  DBPersistentStoreCoordinatorsTableViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 28.02.2017.
//
//

#import "DBPersistentStoreCoordinatorsTableViewController.h"
#import "UILabel+DBDebugToolkit.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBTitleValueTableViewCell.h"

static NSString *const DBPersistentStoreCoordinatorsTableViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";

@interface DBPersistentStoreCoordinatorsTableViewController ()

@property (nonatomic, strong) UILabel *backgroundLabel;

@end

@implementation DBPersistentStoreCoordinatorsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTitleValueTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBPersistentStoreCoordinatorsTableViewControllerTitleValueCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.tableFooterView = [UIView new];
    [self setupBackgroundLabel];
}

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
}

#pragma mark - Private helpers

- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithIndexPath:(NSIndexPath *)indexPath {
    return [self.coreDataToolkit.persistentStoreCoordinators objectAtIndex:indexPath.row];
}

- (DBTitleValueTableViewCellDataSource *)dataSourceForCellWithIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [self titleForCellWithIndexPath:indexPath];
    NSString *value = [self valueForCellWithIndexPath:indexPath];
    return [DBTitleValueTableViewCellDataSource dataSourceWithTitle:title
                                                              value:value];
}

- (NSString *)titleForCellWithIndexPath:(NSIndexPath *)indexPath {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinatorWithIndexPath:indexPath];
    NSMutableArray *storeNames = [NSMutableArray array];
    for (NSPersistentStore *store in persistentStoreCoordinator.persistentStores) {
        [storeNames addObject:store.URL.lastPathComponent];
    }
    return [storeNames componentsJoinedByString:@", "];
}

- (NSString *)valueForCellWithIndexPath:(NSIndexPath *)indexPath {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinatorWithIndexPath:indexPath];
    NSMutableArray *entities = [NSMutableArray array];
    for (NSEntityDescription *entityDescription in persistentStoreCoordinator.managedObjectModel.entities) {
        [entities addObject:entityDescription.name];
    }
    return [entities componentsJoinedByString:@", "];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self persistentStoreCoordinatorWithIndexPath:indexPath];
    [self.delegate persistentStoreCoordinatorsTableViewController:self didSelectPersistentStoreCoordinator:persistentStoreCoordinator];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfItems = self.coreDataToolkit.persistentStoreCoordinators.count;
    self.backgroundLabel.text = numberOfItems == 0 ? @"There are no persistent store coordinators." : @"";
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBTitleValueTableViewCell *titleValueCell = [self.tableView dequeueReusableCellWithIdentifier:DBPersistentStoreCoordinatorsTableViewControllerTitleValueCellIdentifier];
    DBTitleValueTableViewCellDataSource *dataSource = [self dataSourceForCellWithIndexPath:indexPath];
    [titleValueCell configureWithDataSource:dataSource];
    titleValueCell.separatorInset = UIEdgeInsetsZero;
    titleValueCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return titleValueCell;
}

@end
