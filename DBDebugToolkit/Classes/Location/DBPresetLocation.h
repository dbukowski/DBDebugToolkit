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
 `DBPresetLocation` is a simple wrapper that contains all the basic information about a preset location.
 */
@interface DBPresetLocation : NSObject

/**
 Creates and returns a new instance wrapping the information about a preset location.
 
 @param title Simple title describing the location.
 @param latitude The latitude of the location.
 @param longitude The longitude of the location.
 */
+ (instancetype)presetLocationWithTitle:(NSString *)title latitude:(CGFloat)latitude longitude:(CGFloat)longitude;

/**
 Simple title describing the location, e.g. "San Francisco, CA, USA". Read-only.
 */
@property (nonatomic, readonly) NSString *title;

/**
 The latitude of the location. Read-only.
 */
@property (nonatomic, readonly) CGFloat latitude;

/**
 The longitude of the location. Read-only.
 */
@property (nonatomic, readonly) CGFloat longitude;

@end
