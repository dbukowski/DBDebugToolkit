//
//  DBManagedObjectsListTableViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 28.02.2017.
//
//

#import "DBManagedObjectsListTableViewController.h"
#import "UILabel+DBDebugToolkit.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBManagedObjectTableViewCell.h"

static NSString *const DBManagedObjectsListTableViewControllerManagedObjectCellIdentifier = @"DBManagedObjectTableViewCell";

@interface DBManagedObjectsListTableViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) UILabel *backgroundLabel;

@end

@implementation DBManagedObjectsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.entityName];
    self.managedObjects = [self.managedObjectContext executeFetchRequest:request error:nil];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBManagedObjectTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBManagedObjectsListTableViewControllerManagedObjectCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.tableFooterView = [UIView new];
    [self setupBackgroundLabel];
}

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfItems = self.managedObjects.count;
    self.backgroundLabel.text = numberOfItems == 0 ? @"There are no results." : @"";
    self.title = numberOfItems == 1 ? @"1 object" : [NSString stringWithFormat:@"%ld objects", numberOfItems];
    return numberOfItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBManagedObjectTableViewCell *managedObjectTableViewCell = [tableView dequeueReusableCellWithIdentifier:DBManagedObjectsListTableViewControllerManagedObjectCellIdentifier];
    NSManagedObject *managedObject = self.managedObjects[indexPath.row];
    [managedObjectTableViewCell configureWithManagedObject:managedObject];
    return managedObjectTableViewCell;
}

@end
