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

@class DBColorCheckbox;

/**
 A protocol used for informing about the checkbox state.
 */
@protocol DBColorCheckboxDelegate

/**
 Informs the delegate that the checkbox value was changed.
 
 @param colorCheckbox The checkbox that changed its value.
 @param newValue The new checkbox value.
 */
- (void)colorCheckbox:(DBColorCheckbox *)colorCheckbox didChangeValue:(BOOL)newValue;

@end

/**
 `DBColorCheckbox` is a simple `UIControl` subclass designed for selecting a specified color.
 */
@interface DBColorCheckbox : UIControl

/**
 Delegate that will be informed about the checkbox value. It needs to conform to `DBColorCheckboxDelegate` protocol.
 */
@property (nonatomic, weak) id <DBColorCheckboxDelegate> delegate;

/**
 Current value of the checkbox.
 */
@property (nonatomic, assign) BOOL isChecked;

/**
 Color selected by the checkbox.
 */
@property (nonatomic, strong) UIColor *color;

/**
 Color used for drawing the check mark.
 */
@property (nonatomic, strong) UIColor *checkMarkColor;

@end
