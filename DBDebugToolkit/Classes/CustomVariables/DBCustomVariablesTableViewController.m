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

#import "DBCustomVariablesTableViewController.h"
#import "UILabel+DBDebugToolkit.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBMenuSwitchTableViewCell.h"
#import "DBTextViewTableViewCell.h"

typedef NS_ENUM(NSUInteger, DBCustomVariablesTableViewControllerSection) {
    DBCustomVariablesTableViewControllerSectionStringVariables,
    DBCustomVariablesTableViewControllerSectionIntVariables,
    DBCustomVariablesTableViewControllerSectionDoubleVariables,
    DBCustomVariablesTableViewControllerSectionBoolVariables
};

static NSString *const DBCustomVariablesTableViewControllerSwitchCellIdentifier = @"DBMenuSwitchTableViewCell";
static NSString *const DBCustomVariablesTableViewControllerTextViewCellIdentifier = @"DBTextViewTableViewCell";
static NSString *const DBCustomVariablesTableViewControllerIntegerRegex = @"-?[0-9]*";
static NSString *const DBCustomVariablesTableViewControllerDoubleRegex = @"-?[0-9]*([0-9]\\.)?[0-9]*";

@interface DBCustomVariablesTableViewController () <DBMenuSwitchTableViewCellDelegate, DBTextViewTableViewCellDelegate>

@property (nonatomic, strong) NSArray <DBCustomVariable *> *stringVariables;
@property (nonatomic, strong) NSArray <DBCustomVariable *> *boolVariables;
@property (nonatomic, strong) NSArray <DBCustomVariable *> *intVariables;
@property (nonatomic, strong) NSArray <DBCustomVariable *> *doubleVariables;
@property (nonatomic, strong) UILabel *backgroundLabel;

@end

@implementation DBCustomVariablesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBMenuSwitchTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBCustomVariablesTableViewControllerSwitchCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTextViewTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBCustomVariablesTableViewControllerTextViewCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    [self setupBackgroundLabel];
}

#pragma mark - Background label

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
    [self refreshBackgroundLabel];
}

- (void)refreshBackgroundLabel {
    NSInteger presentedVariablesCount = self.stringVariables.count + self.boolVariables.count + self.intVariables.count + self.doubleVariables.count;
    self.backgroundLabel.text = presentedVariablesCount == 0 ? @"There are no custom variables." : @"";
}

#pragma mark - Custom variables

- (void)setCustomVariables:(NSArray<DBCustomVariable *> *)customVariables {
    self.stringVariables = [self customVariablesWithType:DBCustomVariableTypeString fromArray:customVariables];
    self.boolVariables = [self customVariablesWithType:DBCustomVariableTypeBool fromArray:customVariables];
    self.intVariables = [self customVariablesWithType:DBCustomVariableTypeInt fromArray:customVariables];
    self.doubleVariables = [self customVariablesWithType:DBCustomVariableTypeDouble fromArray:customVariables];
    [self refreshBackgroundLabel];
}

- (NSArray <DBCustomVariable *> *)customVariablesWithType:(DBCustomVariableType)type fromArray:(NSArray<DBCustomVariable *> *)customVariables {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %d", type];
    return [customVariables filteredArrayUsingPredicate:predicate];
}

- (DBCustomVariable *)customVariableWithIndexPath:(NSIndexPath *)indexPath {
    DBCustomVariablesTableViewControllerSection section = (DBCustomVariablesTableViewControllerSection)indexPath.section;
    switch (section) {
        case DBCustomVariablesTableViewControllerSectionStringVariables:
            return self.stringVariables[indexPath.row];
        case DBCustomVariablesTableViewControllerSectionDoubleVariables:
            return self.doubleVariables[indexPath.row];
        case DBCustomVariablesTableViewControllerSectionIntVariables:
            return self.intVariables[indexPath.row];
        case DBCustomVariablesTableViewControllerSectionBoolVariables:
            return self.boolVariables[indexPath.row];
        default:
            return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DBCustomVariablesTableViewControllerSectionStringVariables:
            return self.stringVariables.count;
        case DBCustomVariablesTableViewControllerSectionIntVariables:
            return self.intVariables.count;
        case DBCustomVariablesTableViewControllerSectionDoubleVariables:
            return self.doubleVariables.count;
        case DBCustomVariablesTableViewControllerSectionBoolVariables:
            return self.boolVariables.count;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section] == 0) {
        return nil;
    }
    switch (section) {
        case DBCustomVariablesTableViewControllerSectionStringVariables:
            return @"Strings";
        case DBCustomVariablesTableViewControllerSectionIntVariables:
            return @"Integers";
        case DBCustomVariablesTableViewControllerSectionDoubleVariables:
            return @"Doubles";
        case DBCustomVariablesTableViewControllerSectionBoolVariables:
            return @"Booleans";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBCustomVariablesTableViewControllerSection section = (DBCustomVariablesTableViewControllerSection)indexPath.section;
    switch (section) {
        case DBCustomVariablesTableViewControllerSectionStringVariables:
        case DBCustomVariablesTableViewControllerSectionIntVariables:
        case DBCustomVariablesTableViewControllerSectionDoubleVariables:
            return [self textViewCellWithIndexPath:indexPath];
        case DBCustomVariablesTableViewControllerSectionBoolVariables:
            return [self boolVariableCellWithRow:indexPath.row];
        default:
            return nil;
    }
}

#pragma mark - DBTextViewTableViewCellDelegate

- (void)textViewTableViewCellDidChangeText:(DBTextViewTableViewCell *)textViewCell {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:textViewCell];
    CGPoint currentContentOffset = self.tableView.contentOffset;
    [UIView setAnimationsEnabled:NO];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    [self.tableView setContentOffset:currentContentOffset animated:NO];
    DBCustomVariable *customVariable = [self customVariableWithIndexPath:cellIndexPath];
    [self updateCustomVariable:customVariable withValueFromText:textViewCell.textView.text];
}

- (BOOL)textViewTableViewCell:(DBTextViewTableViewCell *)textViewCell shouldChangeTextTo:(NSString *)text {
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:textViewCell];
    DBCustomVariablesTableViewControllerSection section = (DBCustomVariablesTableViewControllerSection)cellIndexPath.section;
    switch (section) {
        case DBCustomVariablesTableViewControllerSectionIntVariables:
            return [self isTextInt:text];
        case DBCustomVariablesTableViewControllerSectionDoubleVariables:
            return [self isTextDouble:text];
        default:
            return YES;
    }
}

#pragma mark - DBMenuSwitchTableViewCell

- (void)menuSwitchTableViewCell:(DBMenuSwitchTableViewCell *)menuSwitchTableViewCell didSetOn:(BOOL)isOn {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:menuSwitchTableViewCell];
    DBCustomVariable *variable = self.boolVariables[indexPath.row];
    variable.value = @(isOn);
}

#pragma mark - Private methods

#pragma mark - - Section heights

- (CGFloat)heightForFooterAndHeaderInSection:(NSInteger)section {
    return [self tableView:self.tableView numberOfRowsInSection:section] > 0 ? UITableViewAutomaticDimension : CGFLOAT_MIN;
}

#pragma mark - - Parsing values

- (void)updateCustomVariable:(DBCustomVariable *)variable withValueFromText:(NSString *)text {
    switch (variable.type) {
        case DBCustomVariableTypeString:
            variable.value = text;
            break;
        case DBCustomVariableTypeInt:
            if (text.length > 0) {
                variable.value = [self integerFromText:text];
            }
            break;
        case DBCustomVariableTypeDouble:
            if (text.length > 0) {
                variable.value = [self doubleFromText:text];
            }
            break;
        default:
            return;
    }
}

- (BOOL)isTextDouble:(NSString *)text {
    return [self isText:text matchingRegex:DBCustomVariablesTableViewControllerDoubleRegex];
}

- (BOOL)isTextInt:(NSString *)text {
    return [self isText:text matchingRegex:DBCustomVariablesTableViewControllerIntegerRegex];
}

- (BOOL)isText:(NSString *)text matchingRegex:(NSString *)regex {
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regexPredicate evaluateWithObject:text];
}

- (NSNumber *)integerFromText:(NSString *)text {
    NSInteger integerValue = [text integerValue];
    return [NSNumber numberWithInteger:integerValue];
}

- (NSNumber *)doubleFromText:(NSString *)text {
    CGFloat doubleValue = [text doubleValue];
    return [NSNumber numberWithDouble:doubleValue];
}

#pragma mark - - Cells

- (DBTextViewTableViewCell *)textViewCellWithIndexPath:(NSIndexPath *)indexPath {
    DBTextViewTableViewCell *cell = (DBTextViewTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:DBCustomVariablesTableViewControllerTextViewCellIdentifier];
    DBCustomVariable *variable = [self customVariableWithIndexPath:indexPath];
    cell.titleLabel.text = variable.name;
    cell.textView.text = [NSString stringWithFormat:@"%@", variable.value];
    cell.textView.keyboardType = indexPath.section == DBCustomVariablesTableViewControllerSectionStringVariables ? UIKeyboardTypeDefault : UIKeyboardTypeNumbersAndPunctuation;
    cell.delegate = self;
    return cell;
}

- (DBMenuSwitchTableViewCell *)boolVariableCellWithRow:(NSInteger)row {
    DBMenuSwitchTableViewCell *switchCell = (DBMenuSwitchTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:DBCustomVariablesTableViewControllerSwitchCellIdentifier];
    DBCustomVariable *variable = self.boolVariables[row];
    switchCell.titleLabel.text = variable.name;
    switchCell.valueSwitch.on = [variable.value boolValue];
    switchCell.delegate = self;
    return switchCell;
}

@end
