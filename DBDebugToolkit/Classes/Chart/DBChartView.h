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
 `DBChartView` is a `UIView` subclass that draws a highly customizable chart.
 */
IB_DESIGNABLE
@interface DBChartView : UIView

/**
 An array of values that should be displayed on the chart.
 */
@property (nonatomic, strong) NSArray *measurements;

/**
 Time in seconds between measurements.
 */
@property (nonatomic, assign) NSTimeInterval measurementInterval;

/**
 Time in seconds between values marked on the x-axis.
 */
@property (nonatomic, assign) NSTimeInterval markedTimesInterval;

/**
 A number specifying the limit of values presented on the chart. 
 Useful for presenting low numbers of measurements with proper scale.
 */
@property (nonatomic, assign) NSInteger measurementsLimit;

/**
 Maximal value of measurements. It's used to present values with proper scale.
 */
@property (nonatomic, assign) CGFloat maxValue;

/**
 A single value that will be marked on the y-axis.
 */
@property (nonatomic, assign) CGFloat markedValue;

/**
 A string format for displaying the marked value next to the y-axis.
 */
@property (nonatomic, strong) NSString *markedValueFormat;

/**
 The color of the chart.
 */
@property (nonatomic, strong) IBInspectable UIColor *chartColor;

/**
 The color of the drawn axes and the marked value.
 */
@property (nonatomic, strong) IBInspectable UIColor *axisColor;

/**
 Boolean property that determines whether the area beneath the plot should be filled.
 */
@property (nonatomic, assign) IBInspectable BOOL filled;

@end
