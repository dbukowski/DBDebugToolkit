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

/**
 `UIWindowShakeDelegate` protocol used to communicate after recognizing shake motion.
 */
@protocol UIWindowShakeDelegate <NSObject>

/**
 Informs a delegate that the window recognized a shake motion.
 
 @param window Window that recognized a shake motion.
 */
- (void)windowDidEndShakeMotion:(UIWindow *)window;

@end

/**
 `UIWindow` category adding methods that add and remove the shake delegates.
 */
@interface UIWindow (DBShakeTrigger)

/**
 Adds new shake delegate to the window.
 
 @param shakeDelegate Delegate that should be added to the window. It needs to implement `UIWindowShakeDelegate` protocol.
 */
- (void)addShakeDelegate:(id <UIWindowShakeDelegate>)shakeDelegate;

/**
 Removes shake delegate from the window.
 
 @param shakeDelegate Delegate that should be removed from the window. It needs to implement `UIWindowShakeDelegate` protocol.
 */
- (void)removeShakeDelegate:(id <UIWindowShakeDelegate>)shakeDelegate;

@end
