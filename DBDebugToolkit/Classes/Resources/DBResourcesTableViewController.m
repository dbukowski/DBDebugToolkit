//
//  DBResourcesTableViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 09.02.2017.
//
//

#import "DBResourcesTableViewController.h"
#import "DBKeychainToolkit.h"
#import "DBUserDefaultsToolkit.h"
#import "DBTitleValueListTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBPersistentStoreCoordinatorsTableViewController.h"
#import "DBEntitiesTableViewController.h"

typedef NS_ENUM(NSUInteger, DBResourcesTableViewControllerSubmenu) {
    DBResourcesTableViewControllerSubmenuFiles,
    DBResourcesTableViewControllerSubmenuUserDefaults,
    DBResourcesTableViewControllerSubmenuKeychain,
    DBResourcesTableViewControllerSubmenuCoreData,
    DBResourcesTableViewControllerSubmenuCookies
};

static NSString *const DBResourcesTableViewControllerUserDefaultsSegueIdentifier = @"UserDefaultsSegue";
static NSString *const DBResourcesTableViewControllerKeychainSegueIdentifier = @"KeychainSegue";

@interface DBResourcesTableViewController () <DBPersistentStoreCoordinatorsTableViewControllerDelegate>

@end

@implementation DBResourcesTableViewController

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DBResourcesTableViewControllerUserDefaultsSegueIdentifier]) {
        DBTitleValueListTableViewController *titleValueListTableViewController = (DBTitleValueListTableViewController *)segue.destinationViewController;
        titleValueListTableViewController.viewModel = [DBUserDefaultsToolkit new];
    } else if ([segue.identifier isEqualToString:DBResourcesTableViewControllerKeychainSegueIdentifier]) {
        DBTitleValueListTableViewController *titleValueListTableViewController = (DBTitleValueListTableViewController *)segue.destinationViewController;
        titleValueListTableViewController.viewModel = [DBKeychainToolkit new];
    }
}

- (void)openPersistentStoreCoordinatorsTableViewController {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBPersistentStoreCoordinatorsTableViewController" bundle:bundle];
    DBPersistentStoreCoordinatorsTableViewController *storeCoordinatorsViewController = [storyboard instantiateInitialViewController];
    storeCoordinatorsViewController.coreDataToolkit = self.coreDataToolkit;
    storeCoordinatorsViewController.delegate = self;
    [self.navigationController pushViewController:storeCoordinatorsViewController animated:YES];
}

- (void)proceedWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBEntitiesTableViewController" bundle:bundle];
    DBEntitiesTableViewController *entitiesTableViewController = [storyboard instantiateInitialViewController];
    entitiesTableViewController.persistentStoreCoordinator = persistentStoreCoordinator;
    [self.navigationController pushViewController:entitiesTableViewController animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DBResourcesTableViewControllerSubmenuCoreData) {
        if (self.coreDataToolkit.persistentStoreCoordinators.count == 1) {
            [self proceedWithPersistentStoreCoordinator:self.coreDataToolkit.persistentStoreCoordinators.firstObject];
        } else {
            [self openPersistentStoreCoordinatorsTableViewController];
        }
    }
}

#pragma mark - DBPersistentStoreCoordinatorsTableViewControllerDelegate

- (void)persistentStoreCoordinatorsTableViewController:(DBPersistentStoreCoordinatorsTableViewController *)persistentStoreCoordinatorsTableViewController didSelectPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    [self proceedWithPersistentStoreCoordinator:persistentStoreCoordinator];
}

@end
