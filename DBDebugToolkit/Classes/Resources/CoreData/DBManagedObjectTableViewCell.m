//
//  DBManagedObjectTableViewCell.m
//  Pods
//
//  Created by Dariusz Bukowski on 01.03.2017.
//
//

#import "DBManagedObjectTableViewCell.h"

static NSString *const DBManagedObjectTableViewCellTitleValueCellIdentifier = @"TitleValueCell";

@interface DBManagedObjectTableViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (nonatomic, strong) NSManagedObject *managedObject;
@property (nonatomic, strong) NSArray <NSString *> *attributeNames;

@end

@implementation DBManagedObjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)configureWithManagedObject:(NSManagedObject *)managedObject {
    self.managedObject = managedObject;
    self.attributeNames = managedObject.entity.attributesByName.allKeys;
    [self.tableView reloadData];
    self.tableViewHeightConstraint.constant = self.tableView.contentSize.height;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 24;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DBManagedObjectTableViewCellTitleValueCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:DBManagedObjectTableViewCellTitleValueCellIdentifier];
        cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
        cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:12];
    }
    NSString *attributeName = self.attributeNames[indexPath.row];
    cell.textLabel.text = attributeName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.managedObject valueForKey:attributeName]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.attributeNames.count;
}

@end
