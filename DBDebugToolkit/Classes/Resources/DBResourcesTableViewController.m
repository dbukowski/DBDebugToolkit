//
//  DBResourcesTableViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 09.02.2017.
//
//

#import "DBResourcesTableViewController.h"
#import "DBKeychainListViewModel.h"
#import "DBUserDefaultsListViewModel.h"
#import "DBTitleValueListTableViewController.h"

static NSString *const DBResourcesTableViewControllerUserDefaultsSegueIdentifier = @"UserDefaultsSegue";
static NSString *const DBResourcesTableViewControllerKeychainSegueIdentifier = @"KeychainSegue";

@interface DBResourcesTableViewController ()

@end

@implementation DBResourcesTableViewController

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:DBResourcesTableViewControllerUserDefaultsSegueIdentifier]) {
        DBTitleValueListTableViewController *titleValueListTableViewController = (DBTitleValueListTableViewController *)segue.destinationViewController;
        titleValueListTableViewController.viewModel = [DBUserDefaultsListViewModel new];
    } else if ([segue.identifier isEqualToString:DBResourcesTableViewControllerKeychainSegueIdentifier]) {
        DBTitleValueListTableViewController *titleValueListTableViewController = (DBTitleValueListTableViewController *)segue.destinationViewController;
        titleValueListTableViewController.viewModel = [DBKeychainListViewModel new];
    }
}

@end
