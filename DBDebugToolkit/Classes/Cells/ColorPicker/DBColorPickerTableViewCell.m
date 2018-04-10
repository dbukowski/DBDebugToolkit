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

#import "DBColorPickerTableViewCell.h"
#import "DBColorCheckbox.h"

@interface DBColorPickerTableViewCell () <DBColorCheckboxDelegate>

@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox1;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox2;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox3;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox4;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox5;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox6;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox7;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox8;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox9;
@property (nonatomic, weak) IBOutlet DBColorCheckbox *colorCheckbox10;
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation DBColorPickerTableViewCell

- (void)configureWithPrimaryColors:(NSArray<UIColor *> *)primaryColors
                   secondaryColors:(NSArray<UIColor *> *)secondaryColors
                     selectedIndex:(NSInteger)selectedIndex {
    NSArray <DBColorCheckbox *> *colorCheckboxes = [self colorCheckboxes];
    [colorCheckboxes enumerateObjectsUsingBlock:^(DBColorCheckbox * _Nonnull checkbox, NSUInteger index, BOOL * _Nonnull stop) {
        checkbox.color = primaryColors[index];
        checkbox.checkMarkColor = secondaryColors[index];
        checkbox.delegate = self;
    }];
    self.selectedIndex = selectedIndex;
}

#pragma mark - Private methods

- (NSArray <DBColorCheckbox *> *)colorCheckboxes {
    return @[self.colorCheckbox1,
             self.colorCheckbox2,
             self.colorCheckbox3,
             self.colorCheckbox4,
             self.colorCheckbox5,
             self.colorCheckbox6,
             self.colorCheckbox7,
             self.colorCheckbox8,
             self.colorCheckbox9,
             self.colorCheckbox10];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    NSArray <DBColorCheckbox *> *colorCheckboxes = [self colorCheckboxes];
    [colorCheckboxes enumerateObjectsUsingBlock:^(DBColorCheckbox * _Nonnull checkbox, NSUInteger index, BOOL * _Nonnull stop) {
        checkbox.isChecked = index == selectedIndex;
    }];
    [self.delegate colorPickerCell:self didSelectColorAtIndex:selectedIndex];
}

#pragma mark - DBColorCheckboxDelegate

- (void)colorCheckbox:(DBColorCheckbox *)colorCheckbox didChangeValue:(BOOL)newValue {
    if (newValue == YES) {
        self.selectedIndex = [[self colorCheckboxes] indexOfObject:colorCheckbox];
    }
}

@end
