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
#import "DBPerformanceWidgetView.h"

@class DBPerformanceToolkit;

/**
 A protocol used for informing about refreshing the performance data.
 */
@protocol DBPerformanceToolkitDelegate <NSObject>

/**
 Informs the delegate that there are new stats available.
 @param performanceToolkit The object that refreshed stats and can now be accessed to retrieve them.
 */
- (void)performanceToolkitDidUpdateStats:(DBPerformanceToolkit *)performanceToolkit;

@end

/**
 `DBPerformanceToolkit` is a class responsible for the features seen in the `DBPerformanceTableViewController`.
 It calculates the performance stats, handles showing widget and can also simulate memory warning.
 */
@interface DBPerformanceToolkit : NSObject

/**
 Delegate that will be informed about new stats available. It needs to conform to `DBPerformanceToolkitDelegate` protocol.
 */
@property (nonatomic, weak) id <DBPerformanceToolkitDelegate> delegate;

/**
 Created widget showing current CPU usage, memory usage and frames per second value.
 */
@property (nonatomic, readonly) DBPerformanceWidgetView *widget;

/**
 Boolean determining whether the widget should be shown or not.
 */
@property (nonatomic, assign) BOOL isWidgetShown;

///----------
/// @name CPU
///----------

/**
 An array of last measurements of the CPU usage.
 */
@property (nonatomic, readonly) NSArray *cpuMeasurements;

/**
 Current CPU usage.
 */
@property (nonatomic, readonly) CGFloat currentCPU;

/**
 Maximal recorded CPU usage.
 */
@property (nonatomic, readonly) CGFloat maxCPU;

///-------------
/// @name Memory
///-------------

/**
 An array of last measurements of the memory usage.
 */
@property (nonatomic, readonly) NSArray *memoryMeasurements;

/**
 Current memory usage.
 */
@property (nonatomic, readonly) CGFloat currentMemory;

/**
 Maximal recorded memory usage.
 */
@property (nonatomic, readonly) CGFloat maxMemory;

///----------
/// @name FPS
///----------

/**
 An array of last measurements of the frames per second value.
 */
@property (nonatomic, readonly) NSArray *fpsMeasurements;

/**
 Current frames per second value.
 */
@property (nonatomic, readonly) CGFloat currentFPS;

/**
 Minimal recorded frames per second value.
 */
@property (nonatomic, readonly) CGFloat minFPS;

/**
 Maximal recorded frames per second value.
 */
@property (nonatomic, readonly) CGFloat maxFPS;

/**
 The limit of memorized measurements. When reached, a new measurement will override the oldest one.
 */
@property (nonatomic, readonly) NSInteger measurementsLimit;

///---------------------
/// @name Initialization
///---------------------

/**
 Initializes `DBPerformanceToolkit` object with provided delegate, that will be informed about widget taps.
 
 @param widgetDelegate A delegate for the performance widget. It has to conform to `DBPerformanceWidgetViewDelegate` protocol.
 */
- (instancetype)initWithWidgetDelegate:(id <DBPerformanceWidgetViewDelegate>)widgetDelegate;

/**
 Simulates the memory warning.
 */
- (void)simulateMemoryWarning;

/**
 Returns time in seconds between the measurements.
 */
- (NSTimeInterval)timeBetweenMeasurements;

@end
