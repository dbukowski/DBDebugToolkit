//
//  DBEntitiesTableViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 28.02.2017.
//
//

#import "DBEntitiesTableViewController.h"
#import "UILabel+DBDebugToolkit.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBManagedObjectsListTableViewController.h"
#import <CoreData/CoreData.h>

static NSString *const DBEntitiesTableViewControllerCellIdentifier = @"EntityCell";

@interface DBEntitiesTableViewController ()

@property (nonatomic, strong) UILabel *backgroundLabel;
@property (nonatomic, strong) NSArray *entities;

@end

@implementation DBEntitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.entities = self.persistentStoreCoordinator.managedObjectModel.entities;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.tableFooterView = [UIView new];
    [self setupBackgroundLabel];
}

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSEntityDescription *entityDescription = [self.entities objectAtIndex:indexPath.row];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBManagedObjectsListTableViewController" bundle:bundle];
    DBManagedObjectsListTableViewController *managedObjectsListViewController = [storyboard instantiateInitialViewController];
    managedObjectsListViewController.persistentStoreCoordinator = self.persistentStoreCoordinator;
    managedObjectsListViewController.entityName = entityDescription.name;
    [self.navigationController pushViewController:managedObjectsListViewController animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfItems = self.entities.count;
    self.backgroundLabel.text = numberOfItems == 0 ? @"There are no entities." : @"";
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:DBEntitiesTableViewControllerCellIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:DBEntitiesTableViewControllerCellIdentifier];
        tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        tableViewCell.separatorInset = UIEdgeInsetsZero;
    }
    NSEntityDescription *entityDescription = [self.entities objectAtIndex:indexPath.row];
    tableViewCell.textLabel.text = entityDescription.name;
    return tableViewCell;
}

@end
