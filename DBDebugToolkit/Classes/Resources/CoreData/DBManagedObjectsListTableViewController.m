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

#import "DBManagedObjectsListTableViewController.h"
#import "UILabel+DBDebugToolkit.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBManagedObjectTableViewCell.h"
#import "DBManagedObjectTableViewController.h"
#import "DBCoreDataFilterSettings.h"
#import "DBCoreDataFilterSettingsTableViewController.h"

static NSString *const DBManagedObjectsListTableViewControllerManagedObjectCellIdentifier = @"DBManagedObjectTableViewCell";

@interface DBManagedObjectsListTableViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *filterButton;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UILabel *backgroundLabel;
@property (nonatomic, strong) NSArray <NSManagedObject *> *filteredManagedObjects;
@property (nonatomic, strong) DBCoreDataFilterSettings *filterSettings;

@end

@implementation DBManagedObjectsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.managedObjects == nil && self.persistentStoreCoordinator != nil) {
        [self setupManagedObjects];
    }
    [self setupTableView];
    [self setupBackgroundLabel];
    [self setupFilterSettings];
    self.filterButton.enabled = self.filterSettings.attributesForSorting.count > 0 || self.filterSettings.attributesForFiltering > 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshFilteredManagedObjects];
}

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
}

- (void)setupTableView {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBManagedObjectTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBManagedObjectsListTableViewControllerManagedObjectCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.tableFooterView = [UIView new];
}

- (void)setupManagedObjects {
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entity.name];
    self.managedObjects = [self.managedObjectContext executeFetchRequest:request error:nil];
}

- (void)setupFilterSettings {
    self.filterSettings = [DBCoreDataFilterSettings defaultFilterSettingsForEntity:self.entity];
}

- (void)refreshFilteredManagedObjects {
    NSPredicate *predicate = self.filterSettings.predicate;
    NSArray *filteredManagedObjects = predicate ? [self.managedObjects filteredArrayUsingPredicate:self.filterSettings.predicate] : self.managedObjects;
    NSSortDescriptor *sortDescriptor = self.filterSettings.sortDescriptor;
    self.filteredManagedObjects = sortDescriptor ? [filteredManagedObjects sortedArrayUsingDescriptors:@[ self.filterSettings.sortDescriptor ]] : filteredManagedObjects;
    self.title = self.filteredManagedObjects.count == 1 ? @"1 object" : [NSString stringWithFormat:@"%ld objects", (unsigned long)self.filteredManagedObjects.count];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfItems = self.filteredManagedObjects.count;
    self.backgroundLabel.text = numberOfItems == 0 ? @"There are no results." : @"";
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBManagedObjectTableViewCell *managedObjectTableViewCell = [tableView dequeueReusableCellWithIdentifier:DBManagedObjectsListTableViewControllerManagedObjectCellIdentifier];
    NSManagedObject *managedObject = self.filteredManagedObjects[indexPath.row];
    [managedObjectTableViewCell configureWithManagedObject:managedObject];
    return managedObjectTableViewCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *managedObject = self.filteredManagedObjects[indexPath.row];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBManagedObjectTableViewController" bundle:bundle];
    DBManagedObjectTableViewController *managedObjectTableViewController = [storyboard instantiateInitialViewController];
    managedObjectTableViewController.managedObject = managedObject;
    [self.navigationController pushViewController:managedObjectTableViewController animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DBCoreDataFilterSettingsTableViewController class]]) {
        DBCoreDataFilterSettingsTableViewController *filterSettingsTableViewController = (DBCoreDataFilterSettingsTableViewController *)segue.destinationViewController;
        filterSettingsTableViewController.filterSettings = self.filterSettings;
        
    }
}

@end
