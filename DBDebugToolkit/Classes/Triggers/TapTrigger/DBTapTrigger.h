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

#import <Foundation/Foundation.h>
#import "DBDebugToolkitTrigger.h"

/**
 `DBTapTrigger` is one of the provided `DBDebugToolkitTrigger` protocol implementations.
 It fires on the tap gesture, when `numberOfTouchesRequired` are tapped `numberOfTapsRequired` times.
 */
@interface DBTapTrigger : NSObject <DBDebugToolkitTrigger>

/**
 Number of taps required for the trigger to fire. It has the default value equal 2.
 */
@property (nonatomic, readonly) NSUInteger numberOfTapsRequired;

/**
 Number of touches required for the trigger to fire. It has the default value equal 2.
 */
@property (nonatomic, readonly) NSUInteger numberOfTouchesRequired;


///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns a `DBTapTrigger` object that requires 2 fingers to be tapped twice.
 */
+ (nonnull instancetype)trigger;

/**
 Creates and returns a `DBTapTrigger` object that requires 2 fingers to be tapped.
 
 @param numberOfTapsRequired Number of taps needed for the trigger to be fired.
 */
+ (nonnull instancetype)triggerWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired;

/**
 Creates and returns a `DBTapTrigger` object that requires 2 taps.
 
 @param numberOfTouchesRequired Number of tapping fingers needed for the trigger to be fired. 
 */
+ (nonnull instancetype)triggerWithNumberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired;


/**
 Creates and returns a fully specified `DBTapTrigger`.
 
 @param numberOfTapsRequired Number of taps needed for the trigger to be fired.
 @param numberOfTouchesRequired Number of tapping fingers needed for the trigger to be fired.
 */
+ (nonnull instancetype)triggerWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                                numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired;

@end
