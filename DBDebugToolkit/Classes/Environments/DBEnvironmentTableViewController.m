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

#import "DBEnvironmentTableViewController.h"
#import "DBTextViewTableViewCell.h"
#import "NSBundle+DBDebugToolkit.h"

@interface DBEnvironmentTableViewController ()

@property (nonatomic, assign) BOOL isChanged;
@property (nonatomic, assign) BOOL isChangedText;
@property (nonatomic, retain) NSArray* selected;

@end

@implementation DBEnvironmentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSBundle *bundle = [NSBundle debugToolkitBundle];

    [self.tableView registerNib:[UINib nibWithNibName:@"DBTextViewTableViewCell" bundle:bundle]
         forCellReuseIdentifier:@"DBEnvironmentCustomReuseID"];
    _selected = [self.viewModel.selectedItems copy];
    
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedInInstancesOfClasses:@[[DBEnvironmentTableViewController class]]];
    if (@available(iOS 13.0, *)) {
        [appearanceLabel setTextColor:UIColor.labelColor];
    } else {
        [appearanceLabel setTextColor:UIColor.blackColor];
    }
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(_isChanged){
        if(![_selected isEqualToArray:self.viewModel.selectedItems]){
            [self.viewModel applyChanges];
        }
    }
    if([_selected isEqualToArray:self.viewModel.selectedItems] && _isChangedText){
        [self.viewModel applyChanges];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.numberOfPresets;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel numberOfItemsInPreset:section];
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel titleForPresetAtIndex:section];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0;
}

-(void) configureCell:(UITableViewCell*)cell withDataSource:(DBTitleValueTableViewCellDataSource*) dataSource andCustomCell:(BOOL) isNotCustom {
    
    if (isNotCustom) {
        cell.textLabel.text = [dataSource.title uppercaseString];
        cell.detailTextLabel.text = dataSource.value;
    } else {
        DBTextViewTableViewCell* textCell = (DBTextViewTableViewCell*) cell;
        textCell.titleLabel.text = [dataSource.title uppercaseString];
        textCell.textView.text = dataSource.value;
        textCell.delegate = self;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DBTitleValueTableViewCellDataSource* dataSrc = [self.viewModel dataSourceForItemAtIndexPath:indexPath];
    BOOL isNotCustomCell = [dataSrc.title isEqualToString:@"custom"] == FALSE;

    NSString* reuseIdentifier =  isNotCustomCell? @"DBEnvironmentReuseID" : @"DBEnvironmentCustomReuseID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [self configureCell:cell withDataSource:dataSrc andCustomCell:isNotCustomCell];
    
    BOOL isSelectedItem = [self.viewModel.selectedItems containsObject:indexPath];
    
    cell.accessoryType = isSelectedItem ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
 
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel didSelectIndexPath:indexPath];
    [self.tableView reloadData];
    _isChanged = true;
}

- (void)textViewTableViewCellDidChangeText:(DBTextViewTableViewCell *)textViewCell {
    NSIndexPath* pathForChangedCustomCell = [self.tableView indexPathForCell:textViewCell];
    [self.viewModel setNewCustomValue:textViewCell.textView.text forIndexPath:pathForChangedCustomCell];
    _isChangedText = true;
}

- (BOOL)textViewTableViewCell:(DBTextViewTableViewCell *)textViewCell shouldChangeTextTo:(NSString *)text {
    return YES;
}

@end
