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

typedef void(^DBCustomActionBody)(void);

/**
 `DBCustomAction` is an object describing an action that will be added to the menu for easy access.
 */
@interface DBCustomAction : NSObject

/**
 Name of the action presented in the menu. Read-only.
 */
@property (nonatomic, readonly, nullable) NSString * name;

///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns a new `DBCustomAction` instance.
 
 @param name The name of the action that will be presented in the menu.
 @param body The block containing the code that should be run when the user selects the created custom action.
 */
+ (nonnull instancetype)customActionWithName:(nullable NSString *)name body:(nullable DBCustomActionBody)body;

///-----------------
/// @name Performing
///-----------------

/**
 Runs the block passed as the action body.
 */
- (void)perform;

@end
