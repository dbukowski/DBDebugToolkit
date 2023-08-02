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
#import <UIKit/UIKit.h>

/**
 `DBGridOverlayColorScheme` is a simple class encapsulating primary and secondary colors used for drawing a grid overlay.
 */
@interface DBGridOverlayColorScheme : NSObject

///---------------------
/// @name Initialization
///---------------------

/**
 Initializes a `DBGridOverlayColorScheme` object with specified colors.
 
 @param primaryColor Color used for drawing a grid.
 @param secondaryColor Color used for drawing the number of pixels in the middle parts of the grid.
 */
- (instancetype)initWithPrimaryColor:(UIColor *)primaryColor secondaryColor:(UIColor *)secondaryColor;

/**
 Creates and returns a `DBGridOverlayColorScheme` object with specified colors.
 
 @param primaryColor Color used for drawing a grid.
 @param secondaryColor Color used for drawing the number of pixels in the middle parts of the grid.
 */
+ (instancetype)colorSchemeWithPrimaryColor:(UIColor *)primaryColor secondaryColor:(UIColor *)secondaryColor;

/**
 Primary color, used for drawing a grid. Read-only.
 */
@property (nonatomic, readonly) UIColor *primaryColor;

/**
 Secondary used for drawing the number of pixels in the middle parts of the grid. used Read-only.
 */
@property (nonatomic, readonly) UIColor *secondaryColor;

@end
