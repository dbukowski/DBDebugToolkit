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

@class DBSliderTableViewCell;

/**
 A protocol used for informing about cell's slider events.
 */
@protocol DBSliderTableViewCellDelegate

/**
 Informs the delegate that the slider value was changed in the cell.
 
 @param sliderCell The cell with a slider that changed its value.
 @param value The new slider value.
 */
- (void)sliderCell:(DBSliderTableViewCell *)sliderCell didSelectValue:(NSInteger)value;

/**
 Informs the delegate that the slider did start editing.
 
 @param sliderCell The cell with a slider that started editing.
 */
- (void)sliderCellDidStartEditingValue:(DBSliderTableViewCell *)sliderCell;

/**
 Informs the delegate that the slider did end editing.
 
 @param sliderCell The cell with a slider that ended editing.
 */
- (void)sliderCellDidEndEditingValue:(DBSliderTableViewCell *)sliderCell;

@end

/**
 `DBSliderTableViewCell` is a simple table view cell subclass with a title label, a `UISlider` instance and a value label.
 */
@interface DBSliderTableViewCell : UITableViewCell

/**
 Delegate that will be informed about slider events. It needs to conform to `DBSliderTableViewCellDelegate` protocol.
 */
@property (nonatomic, weak) id <DBSliderTableViewCellDelegate> delegate;

/**
 An outlet to `UILabel` instance displaying the title of the value changed with the slider.
 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/**
 Sets a specified value on the slider.
 
 @param value Selected value.
 */
- (void)setValue:(NSInteger)value;

/**
 Sets a minimum value of the slider.
 
 @param minValue Minimum value of the slider.
 */
- (void)setMinValue:(NSInteger)minValue;

/**
 Sets a maximum value of the slider.
 
 @param maxValue Maximum value of the slider.
 */
- (void)setMaxValue:(NSInteger)maxValue;

@end
