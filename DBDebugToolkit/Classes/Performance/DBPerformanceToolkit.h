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

@protocol DBPerformanceToolkitDelegate <NSObject>

- (void)performanceToolkitDidUpdateStats:(DBPerformanceToolkit *)performanceToolkit;

@end

@interface DBPerformanceToolkit : NSObject

@property (nonatomic, readonly) DBPerformanceWidgetView *widget;
@property (nonatomic, assign) BOOL isWidgetShown;
@property (nonatomic, weak) id <DBPerformanceToolkitDelegate> delegate;

@property (nonatomic, readonly) NSArray *cpuMeasurements;
@property (nonatomic, readonly) CGFloat currentCPU;
@property (nonatomic, readonly) CGFloat maxCPU;

@property (nonatomic, readonly) NSArray *memoryMeasurements;
@property (nonatomic, readonly) CGFloat currentMemory;
@property (nonatomic, readonly) CGFloat maxMemory;

@property (nonatomic, readonly) NSArray *fpsMeasurements;
@property (nonatomic, readonly) CGFloat currentFPS;
@property (nonatomic, readonly) CGFloat minFPS;
@property (nonatomic, readonly) CGFloat maxFPS;

@property (nonatomic, readonly) NSInteger measurementsLimit;

- (instancetype)initWithWidgetDelegate:(id <DBPerformanceWidgetViewDelegate>)widgetDelegate;

- (void)simulateMemoryWarning;

- (void)updateKeyWindow:(UIWindow *)window;

- (void)windowDidResignKey:(UIWindow *)window;

@end
