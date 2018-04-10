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

@class DBTopLevelView;

/**
 A protocol used for informing about changes in view's visibility.
 */
@protocol DBTopLevelViewDelegate

/**
 Informs the delegate that the view updated its visibility.
 
 @param topLevelView The view that updated its visibility.
 */
- (void)topLevelViewDidUpdateVisibility:(DBTopLevelView *)topLevelView;

@end

/**
 `DBTopLevelView` is a `UIView` instance that is meant for staying on top of the screen at all times.
 */
@interface DBTopLevelView : UIView

/**
 Delegate that will be informed about the changes in the view's visibility. It needs to conform to `DBTopLevelViewDelegate` protocol.
 */
@property (nonatomic, weak) id <DBTopLevelViewDelegate> topLevelViewDelegate;

/**
 Method that is called after every change of the superview's frame, for example after the device rotation.
 */
- (void)updateFrame;

@end
