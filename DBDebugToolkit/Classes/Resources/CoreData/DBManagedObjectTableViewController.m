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

#import "DBManagedObjectTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBTitleValueTableViewCell.h"
#import "DBManagedObjectsListTableViewController.h"

typedef NS_ENUM(NSUInteger, DBManagedObjectTableViewControllerSection) {
    DBManagedObjectTableViewControllerSectionAttributes,
    DBManagedObjectTableViewControllerSectionRelationships
};

static NSString *const DBManagedObjectTableViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";
static NSString *const DBManagedObjectTableViewControllerRelationshipCellIdentifier = @"DBRelationshipCell";

@interface DBManagedObjectTableViewController ()

@property (nonatomic, strong) NSArray <NSString *> *attributeNames;
@property (nonatomic, strong) NSArray <NSString *> *relationshipNames;

@end

@implementation DBManagedObjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.managedObject.entity.name;
    self.attributeNames = self.managedObject.entity.attributesByName.allKeys;
    self.relationshipNames = self.managedObject.entity.relationshipsByName.allKeys;
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTitleValueTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBManagedObjectTableViewControllerTitleValueCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBManagedObjectTableViewControllerSection section = indexPath.section;
    if (section == DBManagedObjectTableViewControllerSectionRelationships) {
        NSString *relationshipName = self.relationshipNames[indexPath.row];
        NSRelationshipDescription *relationship = self.managedObject.entity.relationshipsByName[relationshipName];
        [self showObjectsInRelationship:relationship];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DBManagedObjectTableViewControllerSectionAttributes:
            return self.attributeNames.count;
        case DBManagedObjectTableViewControllerSectionRelationships:
            return self.relationshipNames.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBManagedObjectTableViewControllerSection section = indexPath.section;
    switch (section) {
        case DBManagedObjectTableViewControllerSectionAttributes:
            return [self attributeCellWithRow:indexPath.row];
        case DBManagedObjectTableViewControllerSectionRelationships:
            return [self relationshipCellWithRow:indexPath.row];
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:section];
    if (numberOfRows > 0) {
        switch (section) {
            case DBManagedObjectTableViewControllerSectionAttributes:
                return @"Attributes";
            case DBManagedObjectTableViewControllerSectionRelationships:
                return @"Relationships";
        }
    }
    
    return nil;
}

#pragma mark - Private methods

#pragma mark - - Section heights

- (CGFloat)heightForFooterAndHeaderInSection:(NSInteger)section {
    return [self tableView:self.tableView numberOfRowsInSection:section] > 0 ? UITableViewAutomaticDimension : CGFLOAT_MIN;
}

#pragma mark - - Cells

- (UITableViewCell *)attributeCellWithRow:(NSInteger)row {
    NSString *identifier = DBManagedObjectTableViewControllerTitleValueCellIdentifier;
    DBTitleValueTableViewCell *titleValueCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    NSString *title = self.attributeNames[row];
    NSString *value = [NSString stringWithFormat:@"%@", [self.managedObject valueForKey:title]];
    DBTitleValueTableViewCellDataSource *dataSource = [DBTitleValueTableViewCellDataSource dataSourceWithTitle:title
                                                                                                         value:value];
    [titleValueCell configureWithDataSource:dataSource];
    return titleValueCell;
}

- (UITableViewCell *)relationshipCellWithRow:(NSInteger)row {
    NSString *identifier = DBManagedObjectTableViewControllerRelationshipCellIdentifier;
    UITableViewCell *relationshipCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (relationshipCell == nil) {
        relationshipCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:identifier];
    }
    NSString *title = self.relationshipNames[row];
    BOOL isEnabled = [self.managedObject valueForKey:title] != nil;
    relationshipCell.textLabel.text = title;
    relationshipCell.textLabel.textColor = isEnabled ? [UIColor blackColor] : [UIColor lightGrayColor];
    relationshipCell.accessoryType = isEnabled ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    relationshipCell.selectionStyle = isEnabled ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    return relationshipCell;
}

#pragma mark - - Showing relationships

- (void)showObjectsInRelationship:(NSRelationshipDescription *)relationship {
    if (relationship.isToMany) {
        [self showObjectsInToManyRelationship:relationship];
    } else {
        [self showObjectsInToOneRelationship:relationship];
    }
}

- (void)showObjectsInToOneRelationship:(NSRelationshipDescription *)relationship {
    NSString *relationshipName = relationship.name;
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBManagedObjectTableViewController" bundle:bundle];
    DBManagedObjectTableViewController *managedObjectTableViewController = [storyboard instantiateInitialViewController];
    managedObjectTableViewController.managedObject = (NSManagedObject *)[self.managedObject valueForKey:relationshipName];
    [self.navigationController pushViewController:managedObjectTableViewController animated:YES];
}

- (void)showObjectsInToManyRelationship:(NSRelationshipDescription *)relationship {
    NSString *relationshipName = relationship.name;
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBManagedObjectsListTableViewController" bundle:bundle];
    DBManagedObjectsListTableViewController *managedObjectsListViewController = [storyboard instantiateInitialViewController];
    managedObjectsListViewController.managedObjects = [[self.managedObject valueForKey:relationshipName] allObjects];
    managedObjectsListViewController.entity = relationship.destinationEntity;
    [self.navigationController pushViewController:managedObjectsListViewController animated:YES];
}

@end
