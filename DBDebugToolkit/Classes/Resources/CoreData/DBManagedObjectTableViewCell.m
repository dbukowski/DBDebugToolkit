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
#import "DBManagedObjectTableViewCell.h"

static NSString *const DBManagedObjectTableViewCellTitleValueCellIdentifier = @"TitleValueCell";

@interface DBManagedObjectTableViewCell () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
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
    self.titleLabel.text = managedObject.entity.name;
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
