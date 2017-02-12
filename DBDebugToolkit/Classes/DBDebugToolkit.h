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
 `DBDebugToolkit` provides the interface that can be used to setup and customize the debugging tools.
 */
@interface DBDebugToolkit : NSObject

///------------
/// @name Setup
///------------

/**
 Sets up the `DBDebugToolkit` with one default trigger: `DBShakeTrigger`.
*/
+ (void)setup;

/**
 Sets up the `DBDebugToolkit` with provided triggers.
 
 @param triggers Array of triggers that should be used to open the `DBDebugToolkit` menu. The objects it contains should adopt the protocol `DBDebugToolkitTrigger`.
 */
+ (void)setupWithTriggers:(NSArray <id <DBDebugToolkitTrigger>> *)triggers;

/**
 Enables or disables console output capturing, which by default is enabled.
 
 @param enabled Determines whether console output capturing should be enabled or disabled.
 */
+ (void)setCapturingConsoleOutputEnabled:(BOOL)enabled;

+ (void)clearKeychain;

+ (void)clearUserDefaults;

@end
