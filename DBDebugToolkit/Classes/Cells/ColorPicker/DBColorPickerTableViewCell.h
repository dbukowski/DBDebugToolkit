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

#import <UIKit/UIKit.h>

@class DBColorPickerTableViewCell;

/**
 A protocol used for informing about the selected color.
 */
@protocol DBColorPickerTableViewCellDelegate

/**
 Informs the delegate about the selected color index.
 
 @param colorPickerCell The cell with a color picker that changed the selected color.
 @param index The index of the selected color.
 */
- (void)colorPickerCell:(DBColorPickerTableViewCell *)colorPickerCell didSelectColorAtIndex:(NSInteger)index;

@end

/**
 `DBColorPickerTableViewCell` is a table view cell subclass with a title label, and multiple color checkboxes.
 */
@interface DBColorPickerTableViewCell : UITableViewCell

/**
 An outlet to `UILabel` instance displaying the title of the value changed with the color picker.
 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/**
 Delegate that will be informed about the selected color index. It needs to conform to `DBColorPickerTableViewCellDelegate` protocol.
 */
@property (nonatomic, weak) id <DBColorPickerTableViewCellDelegate> delegate;

/**
 Configures the cell with specified colors and the index of the selected color.
 
 @param primaryColors An array of colors that can be selected in the cell.
 @param secondaryColors An array of colors used for drawing the checkmarks on the the checkboxes.
 @param selectedIndex The index of the currently selected color.
 */
- (void)configureWithPrimaryColors:(NSArray <UIColor *> *)primaryColors
                   secondaryColors:(NSArray <UIColor *> *)secondaryColors
                     selectedIndex:(NSInteger)selectedIndex;

@end
