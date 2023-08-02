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

#import "DBGridOverlaySettingsTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBMenuSwitchTableViewCell.h"
#import "DBSliderTableViewCell.h"
#import "DBColorPickerTableViewCell.h"
#import "DBGridOverlayColorScheme.h"

typedef NS_ENUM(NSUInteger, DBGridOverlaySettingsTableViewControllerSection) {
    DBGridOverlaySettingsTableViewControllerSectionSwitch,
    DBGridOverlaySettingsTableViewControllerSectionSettings
};

typedef NS_ENUM(NSUInteger, DBGridOverlaySettingsTableViewControllerSettingsRow) {
    DBGridOverlaySettingsTableViewControllerSettingsRowSize,
    DBGridOverlaySettingsTableViewControllerSettingsRowOpacity,
    DBGridOverlaySettingsTableViewControllerSettingsRowColor
};

static NSString *const DBGridOverlaySettingsTableViewControllerSwitchCellIdentifier = @"DBMenuSwitchTableViewCell";
static NSString *const DBGridOverlaySettingsTableViewControllerSliderCellIdentifier = @"DBSliderTableViewCell";
static NSString *const DBGridOverlaySettingsTableViewControllerColorPickerCellIdentifier = @"DBColorPickerTableViewCell";

static const NSInteger DBGridOverlaySettingsTableViewControllerMinGridSize = 4.0;
static const NSInteger DBGridOverlaySettingsTableViewControllerMaxGridSize = 64.0;

static const NSInteger DBGridOverlaySettingsTableViewControllerMinOpacity = 10;
static const NSInteger DBGridOverlaySettingsTableViewControllerMaxOpacity = 100;

static const CGFloat DBGridOverlaySemiTransparencyRatio = 0.2;

@interface DBGridOverlaySettingsTableViewController () <DBMenuSwitchTableViewCellDelegate, DBSliderTableViewCellDelegate, DBColorPickerTableViewCellDelegate>

@property (nonatomic, strong) NSArray <UIColor *> *primaryGridColors;
@property (nonatomic, strong) NSArray <UIColor *> *secondaryGridColors;

@end

@implementation DBGridOverlaySettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBMenuSwitchTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBGridOverlaySettingsTableViewControllerSwitchCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBSliderTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBGridOverlaySettingsTableViewControllerSliderCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBColorPickerTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBGridOverlaySettingsTableViewControllerColorPickerCellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
    [self setupGridColors];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)setupGridColors {
    NSMutableArray *primaryColors = [NSMutableArray array];
    NSMutableArray *secondaryColors = [NSMutableArray array];
    for (DBGridOverlayColorScheme *colorScheme in self.userInterfaceToolkit.gridOverlayColorSchemes) {
        [primaryColors addObject:colorScheme.primaryColor];
        [secondaryColors addObject:colorScheme.secondaryColor];
    }
    self.primaryGridColors = [primaryColors copy];
    self.secondaryGridColors = [secondaryColors copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DBGridOverlaySettingsTableViewControllerSection tableViewSection = section;
    switch (tableViewSection) {
        case DBGridOverlaySettingsTableViewControllerSectionSwitch:
            return 1;
        case DBGridOverlaySettingsTableViewControllerSectionSettings:
            return self.userInterfaceToolkit.isGridOverlayShown ? 3 : 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBGridOverlaySettingsTableViewControllerSection section = indexPath.section;
    switch (section) {
        case DBGridOverlaySettingsTableViewControllerSectionSwitch: {
            DBMenuSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:DBGridOverlaySettingsTableViewControllerSwitchCellIdentifier];
            switchCell.titleLabel.text = @"Show grid overlay";
            switchCell.valueSwitch.on = self.userInterfaceToolkit.isGridOverlayShown;
            switchCell.delegate = self;
            return switchCell;
        }
        case DBGridOverlaySettingsTableViewControllerSectionSettings:
            return [self tableView:tableView cellInSettingsSectionForRow:indexPath.row];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellInSettingsSectionForRow:(NSInteger)row {
    DBGridOverlaySettingsTableViewControllerSettingsRow settingsRow = row;
    switch (settingsRow) {
        case DBGridOverlaySettingsTableViewControllerSettingsRowSize: {
            DBSliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:DBGridOverlaySettingsTableViewControllerSliderCellIdentifier];
            sliderCell.titleLabel.text = @"Size";
            sliderCell.delegate = self;
            [sliderCell setMinValue:DBGridOverlaySettingsTableViewControllerMinGridSize];
            [sliderCell setMaxValue:DBGridOverlaySettingsTableViewControllerMaxGridSize];
            [sliderCell setValue:self.userInterfaceToolkit.gridOverlay.gridSize];
            return sliderCell;
        }
        case DBGridOverlaySettingsTableViewControllerSettingsRowOpacity: {
            DBSliderTableViewCell *sliderCell = [tableView dequeueReusableCellWithIdentifier:DBGridOverlaySettingsTableViewControllerSliderCellIdentifier];
            sliderCell.titleLabel.text = @"Opacity";
            sliderCell.delegate = self;
            [sliderCell setMinValue:DBGridOverlaySettingsTableViewControllerMinOpacity];
            [sliderCell setMaxValue:DBGridOverlaySettingsTableViewControllerMaxOpacity];
            [sliderCell setValue:self.userInterfaceToolkit.gridOverlay.opacity * 100];
            return sliderCell;
        }
        case DBGridOverlaySettingsTableViewControllerSettingsRowColor: {
            DBColorPickerTableViewCell *colorPickerCell = [tableView dequeueReusableCellWithIdentifier:DBGridOverlaySettingsTableViewControllerColorPickerCellIdentifier];
            colorPickerCell.titleLabel.text = @"Color";
            colorPickerCell.delegate = self;
            [colorPickerCell configureWithPrimaryColors:self.primaryGridColors
                                        secondaryColors:self.secondaryGridColors
                                          selectedIndex:self.userInterfaceToolkit.selectedGridOverlayColorSchemeIndex];
            return colorPickerCell;
        }
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DBGridOverlaySettingsTableViewControllerSection tableViewSection = section;
    switch (tableViewSection) {
        case DBGridOverlaySettingsTableViewControllerSectionSwitch:
            return nil;
        case DBGridOverlaySettingsTableViewControllerSectionSettings:
            return self.userInterfaceToolkit.isGridOverlayShown ? @"Grid settings" : nil;
    }
}

#pragma mark - DBMenuSwitchTableViewCellDelegate

- (void)menuSwitchTableViewCell:(DBMenuSwitchTableViewCell *)menuSwitchTableViewCell didSetOn:(BOOL)isOn {
    self.userInterfaceToolkit.isGridOverlayShown = isOn;
    NSIndexSet *sectionsToReload = [NSIndexSet indexSetWithIndex:DBGridOverlaySettingsTableViewControllerSectionSettings];
    [self.tableView reloadSections:sectionsToReload withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - DBSliderTableViewCell

- (void)sliderCell:(DBSliderTableViewCell *)sliderCell didSelectValue:(NSInteger)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sliderCell];
    DBGridOverlaySettingsTableViewControllerSettingsRow settingsRow = indexPath.row;
    if (settingsRow == DBGridOverlaySettingsTableViewControllerSettingsRowSize) {
        self.userInterfaceToolkit.gridOverlay.gridSize = value;
    } else {
        self.userInterfaceToolkit.gridOverlay.opacity = (CGFloat)value / 100.0;
    }
}

- (void)sliderCellDidStartEditingValue:(DBSliderTableViewCell *)sliderCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sliderCell];
    DBGridOverlaySettingsTableViewControllerSettingsRow settingsRow = indexPath.row;
    if (settingsRow == DBGridOverlaySettingsTableViewControllerSettingsRowSize) {
        [self setShouldMakeGridSemiTransparent:YES];
    }
}

- (void)sliderCellDidEndEditingValue:(DBSliderTableViewCell *)sliderCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sliderCell];
    DBGridOverlaySettingsTableViewControllerSettingsRow settingsRow = indexPath.row;
    if (settingsRow == DBGridOverlaySettingsTableViewControllerSettingsRowSize) {
        [self setShouldMakeGridSemiTransparent:NO];
    }
}

- (void)setShouldMakeGridSemiTransparent:(BOOL)shouldMakeGridSemiTransparent {
    CGFloat targetAlpha = self.userInterfaceToolkit.gridOverlay.opacity;
    if (shouldMakeGridSemiTransparent) {
        targetAlpha *= DBGridOverlaySemiTransparencyRatio;
    }
    targetAlpha = MAX(MIN(0.2, self.userInterfaceToolkit.gridOverlay.opacity), targetAlpha);
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.userInterfaceToolkit.gridOverlay.alpha = targetAlpha;
                     } completion:nil];
}

#pragma mark - DBColorPickerTableViewCellDelegate

- (void)colorPickerCell:(DBColorPickerTableViewCell *)colorPickerCell didSelectColorAtIndex:(NSInteger)index {
    self.userInterfaceToolkit.selectedGridOverlayColorSchemeIndex = index;
}

@end
