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
 `DBLongPressTrigger` is one of the provided `DBDebugToolkitTrigger` protocol implementations. 
 It fires on the long press gesture, when `numberOfTouchesRequired` are tapped and held for `minumPressDuration`.
 */
@interface DBLongPressTrigger : NSObject <DBDebugToolkitTrigger>

/**
 Number of touches required for the trigger to fire. It has the default value equal 2.
 */
@property (nonatomic, readonly) NSUInteger numberOfTouchesRequired;

/**
 Minimum press duration in seconds required for the trigger to fire. It has the default value equal 0.5.
 */
@property (nonatomic, readonly) NSTimeInterval minimumPressDuration;


///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns a `DBLongPressTrigger` object that requires 2 fingers to be pressed for 0.5 seconds.
 */
+ (nonnull instancetype)trigger;

/**
 Creates and returns a `DBLongPressTrigger` object that requires the touches to be pressed for 0.5 seconds.
 
 @param numberOfTouchesRequired Number of fingers that must be held down for the trigger to be fired.
 */
+ (nonnull instancetype)triggerWithNumberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired;

/**
 Creates and returns a `DBLongPressTrigger` object that requires 2 finger to be pressed.
 
 @param minimumPressDuration Time in seconds the fingers must be held down for the gesture to be recognized.
 */
+ (nonnull instancetype)triggerWithMinimumPressDuration:(NSTimeInterval)minimumPressDuration;

/**
 Creates and returns a fully specified `DBLongPressTrigger`.
 
 @param numberOfTouchesRequired Number of fingers that must be held down for the trigger to be fired.
 @param minimumPressDuration Time in seconds the fingers must be held down for the gesture to be recognized.
 */
+ (nonnull instancetype)triggerWithNumberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
                                      minimumPressDuration:(NSTimeInterval)minimumPressDuration;

@end
