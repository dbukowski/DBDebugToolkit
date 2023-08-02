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

#import "DBCoreDataFilterSettingsTableViewController.h"
#import "DBMenuSwitchTableViewCell.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBOptionsListTableViewController.h"
#import "DBCoreDataFilterTableViewController.h"
#import "UILabel+DBDebugToolkit.h"

typedef NS_ENUM(NSUInteger, DBCoreDataFilterSettingsTableViewControllerSection) {
    DBCoreDataFilterSettingsTableViewControllerSectionSorting,
    DBCoreDataFilterSettingsTableViewControllerSectionFiltering
};

static NSString *const DBCoreDataFilterSettingsTableViewControllerButtonCellIdentifier = @"DBMenuButtonTableViewCell";
static NSString *const DBCoreDataFilterSettingsTableViewControllerSwitchCellIdentifier = @"DBMenuSwitchTableViewCell";
static NSString *const DBCoreDataFilterSettingsTableViewControllerFilterCellIdentifier = @"DBMenuFilterTableViewCell";
static NSString *const DBCoreDataFilterSettingsTableViewControllerSortingAttributeCellIdentifier = @"DBMenuSortingAttributeTableViewCell";

@interface DBCoreDataFilterSettingsTableViewController () <DBMenuSwitchTableViewCellDelegate, DBOptionsListTableViewControllerDelegate, DBOptionsListTableViewControllerDataSource, DBCoreDataFilterTableViewControllerDelegate>

@property (nonatomic, strong) NSNumber *editedFilterIndex;
@property (nonatomic, strong) UILabel *backgroundLabel;

@end

@implementation DBCoreDataFilterSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBMenuSwitchTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBCoreDataFilterSettingsTableViewControllerSwitchCellIdentifier];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self setupBackgroundLabel];
}

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
    BOOL isTableViewEmpty = self.filterSettings.attributesForSorting.count == 0 && self.filterSettings.attributesForFiltering.count == 0;
    self.backgroundLabel.text = isTableViewEmpty ? @"There are no filter settings for this entity." : @"";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DBCoreDataFilterSettingsTableViewControllerSection section = indexPath.section;
    switch (section) {
        case DBCoreDataFilterSettingsTableViewControllerSectionSorting:
            [self handleSelectingCellInSortingSectionWithRow:indexPath.row];
            return;
        case DBCoreDataFilterSettingsTableViewControllerSectionFiltering:
            [self handleSelectingCellInFilteringSectionWithRow:indexPath.row];
            return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBCoreDataFilterSettingsTableViewControllerSection section = indexPath.section;
    switch (section) {
        case DBCoreDataFilterSettingsTableViewControllerSectionSorting:
            return [self cellInSortingSectionWithRow:indexPath.row];
        case DBCoreDataFilterSettingsTableViewControllerSectionFiltering:
            return [self cellInFilteringSectionWithRow:indexPath.row];
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DBCoreDataFilterSettingsTableViewControllerSectionSorting:
            return self.filterSettings.attributesForSorting.count == 0 ? 0 : 2;
        case DBCoreDataFilterSettingsTableViewControllerSectionFiltering:
            return self.filterSettings.attributesForFiltering.count == 0 ? 0 : (self.filterSettings.filters.count + 1);
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:section];
    if (numberOfRows > 0) {
        switch (section) {
            case DBCoreDataFilterSettingsTableViewControllerSectionSorting:
                return @"Sort by";
            case DBCoreDataFilterSettingsTableViewControllerSectionFiltering:
                return @"Filters";
        }
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 && indexPath.row < self.filterSettings.filters.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.filterSettings removeFilterAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - DBMenuSwitchTableViewCellDelegate

- (void)menuSwitchTableViewCell:(DBMenuSwitchTableViewCell *)menuSwitchTableViewCell didSetOn:(BOOL)isOn {
    self.filterSettings.isSortingAscending = isOn;
}

#pragma mark - DBOptionsListTableViewControllerDelegate

- (void)optionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController didSelectOptionAtIndex:(NSInteger)optionIndex {
    self.filterSettings.sortDescriptorAttribute = self.filterSettings.attributesForSorting[optionIndex];
    NSIndexPath *sortingAttributeIndexPath = [NSIndexPath indexPathForRow:0
                                                                inSection:DBCoreDataFilterSettingsTableViewControllerSectionSorting];
    [self.tableView reloadRowsAtIndexPaths:@[ sortingAttributeIndexPath ] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - DBOptionsListTableViewControllerDataSource

- (NSInteger)selectedIndexInOptionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController {
    return [self.filterSettings.attributesForSorting indexOfObject:self.filterSettings.sortDescriptorAttribute];
}

- (NSInteger)numberOfOptionsInOptionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController {
    return self.filterSettings.attributesForSorting.count;
}

- (NSString *)optionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController titleAtIndex:(NSInteger)index {
    NSAttributeDescription *attribute = self.filterSettings.attributesForSorting[index];
    return attribute.name;
}

#pragma mark - DBCoreDataFilterTableViewControllerDelegate

- (void)filterTableViewControllerDidTapClose:(DBCoreDataFilterTableViewController *)filterTableViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)filterTableViewController:(DBCoreDataFilterTableViewController *)filterTableViewController didTapSaveWithFilter:(DBCoreDataFilter *)filter {
    if (self.editedFilterIndex == nil) {
        [self.filterSettings addFilter:filter];
    } else {
        [self.filterSettings saveFilter:filter atIndex:self.editedFilterIndex.integerValue];
    }
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private methods

#pragma mark - - Section heights

- (CGFloat)heightForFooterAndHeaderInSection:(NSInteger)section {
    return [self tableView:self.tableView numberOfRowsInSection:section] > 0 ? UITableViewAutomaticDimension : CGFLOAT_MIN;
}

#pragma mark - - Cells

- (UITableViewCell *)cellInSortingSectionWithRow:(NSInteger)row {
    if (row == 0) {
        UITableViewCell *cell = [self defaultCellWithIdentifier:DBCoreDataFilterSettingsTableViewControllerSortingAttributeCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.filterSettings.sortDescriptorAttribute.name;
        return cell;
    } else {
        DBMenuSwitchTableViewCell *switchTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:DBCoreDataFilterSettingsTableViewControllerSwitchCellIdentifier];
        switchTableViewCell.titleLabel.text = @"Ascending";
        switchTableViewCell.valueSwitch.on = self.filterSettings.isSortingAscending;
        switchTableViewCell.delegate = self;
        return switchTableViewCell;
    }
    
    return nil;
}

- (UITableViewCell *)cellInFilteringSectionWithRow:(NSInteger)row {
    if (row == self.filterSettings.filters.count) {
        UITableViewCell *cell = [self defaultCellWithIdentifier:DBCoreDataFilterSettingsTableViewControllerButtonCellIdentifier];
        cell.textLabel.textColor = cell.tintColor;
        cell.textLabel.text = @"Add filter";
        return cell;
    } else {
        DBCoreDataFilter *filter = self.filterSettings.filters[row];
        UITableViewCell *cell = [self defaultCellWithIdentifier:DBCoreDataFilterSettingsTableViewControllerFilterCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = filter.displayName;
        return cell;
    }
    
}

- (UITableViewCell *)defaultCellWithIdentifier:(NSString *)identifier {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

#pragma mark - - Selection

- (void)handleSelectingCellInSortingSectionWithRow:(NSInteger)row {
    if (row == 0) {
        NSBundle *bundle = [NSBundle debugToolkitBundle];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBOptionsListTableViewController" bundle:bundle];
        DBOptionsListTableViewController *optionsListTableViewController = [storyboard instantiateInitialViewController];
        optionsListTableViewController.delegate = self;
        optionsListTableViewController.dataSource = self;
        optionsListTableViewController.title = @"Attribute";
        [self.navigationController pushViewController:optionsListTableViewController animated:YES];
    }
}

- (void)handleSelectingCellInFilteringSectionWithRow:(NSInteger)row {
    BOOL addsNewFilter = row == self.filterSettings.filters.count;
    self.editedFilterIndex = addsNewFilter ? nil : @(row);
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBCoreDataFilterTableViewController" bundle:bundle];
    DBCoreDataFilterTableViewController *filterTableViewController = [storyboard instantiateInitialViewController];
    filterTableViewController.filter = addsNewFilter ? [self.filterSettings defaultNewFilter] : [self.filterSettings.filters[row] copy];
    filterTableViewController.attributes = self.filterSettings.attributesForFiltering;
    filterTableViewController.delegate = self;
    filterTableViewController.title = addsNewFilter ? @"Add filter" : @"Edit filter";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:filterTableViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
