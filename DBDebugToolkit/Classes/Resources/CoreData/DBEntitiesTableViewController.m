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
    managedObjectsListViewController.entity = entityDescription;
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
