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

@class DBMenuSwitchTableViewCell;

/**
 A protocol used for informing about changes in cell's switch.
 */
@protocol DBMenuSwitchTableViewCellDelegate <NSObject>

/**
 Informs the delegate that the switch value was changed in the cell.
 
 @param menuSwitchTableViewCell The cell with a switch that changed its value.
 @param isOn The new switch value.
 */
- (void)menuSwitchTableViewCell:(DBMenuSwitchTableViewCell *)menuSwitchTableViewCell didSetOn:(BOOL)isOn;

@end

/**
 `DBMenuSwitchTableViewCell` is a simple table view cell subclass with a title label and a `UISwitch` instance.
 */
@interface DBMenuSwitchTableViewCell : UITableViewCell

/**
 Delegate that will be informed about switch value changes. It needs to conform to `DBMenuSwitchTableViewCellDelegate` protocol.
 */
@property (nonatomic, weak) id <DBMenuSwitchTableViewCellDelegate> delegate;

/**
 An outlet to `UILabel` instance displaying the title of the value changed with the switch.
 */
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

/**
 An outlet to `UISwitch` instance.
 */
@property (nonatomic, strong) IBOutlet UISwitch *valueSwitch;

@end
