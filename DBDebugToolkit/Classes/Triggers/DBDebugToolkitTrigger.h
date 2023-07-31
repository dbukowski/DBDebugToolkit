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
#import "DBDebugToolkitTriggerDelegate.h"

#ifndef DBDebugToolkitTrigger_h
#define DBDebugToolkitTrigger_h

/**
 A protocol adopted by all the triggers. It can be used to provide a custom trigger.
 */
@protocol DBDebugToolkitTrigger <NSObject>

/**
 Adds the trigger to a `UIWindow` object. Please note that `UIWindow` inherits from `UIView`, so it is pretty straightforward to add a `UIGestureRecognizer`.
 
 @param window Window that the trigger will be added to.
 */
- (void)addToWindow:(UIWindow *)window;

/**
 Removes the trigger from a `UIWindow` object. Please note that `UIWindow` inherits from `UIView`, so it is pretty straightforward to remove a `UIGestureRecognizer`.
 
 @param window Window that a trigger will be removed from.
 */
- (void)removeFromWindow:(UIWindow *)window;

/**
 A delegate that will be informed about trigger firing. It needs to adopt the `DBDebugToolkitTriggerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBDebugToolkitTriggerDelegate> delegate;

@end

#endif /* DBDebugToolkitTrigger_h */
