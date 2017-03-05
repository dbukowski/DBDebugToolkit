//
//  DBOptionsListTableViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

#import "DBOptionsListTableViewController.h"

static NSString *const DBOptionsListTableViewControllerCellIdentifier = @"DBOptionsListTableViewControllerCell";

@interface DBOptionsListTableViewController ()

@end

@implementation DBOptionsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
    [self.delegate optionsListTableViewController:self didSelectOptionAtIndex:indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfOptionsInOptionsListTableViewController:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DBOptionsListTableViewControllerCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:DBOptionsListTableViewControllerCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BOOL isSelected = indexPath.row == [self.dataSource selectedIndexInOptionsListTableViewController:self];
    cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.textLabel.text = [self.dataSource optionsListTableViewController:self titleAtIndex:indexPath.row];
    return cell;
}

@end
