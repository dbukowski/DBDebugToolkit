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
#import "DBPerformanceSection.h"
#import "DBTopLevelView.h"

@class DBPerformanceWidgetView;

/**
 A protocol used for informing about taps recognized on the widget.
 */
@protocol DBPerformanceWidgetViewDelegate <NSObject>

/**
 Informs the delegate which of the sections was tapped.
 
 @param performanceWidgetView The widget that recognized the tap.
 @param section Tapped section.
 */
- (void)performanceWidgetView:(DBPerformanceWidgetView *)performanceWidgetView didTapOnSection:(DBPerformanceSection)section;

@end

/**
 `DBPerformanceWidgetView` is a simple view that is meant to stay on top of the screen all the time.
 It shows the current CPU usage, memory usage and current frames per second value.
 It can be moved around the window with pan gesture and it recognizes taps.
 */
@interface DBPerformanceWidgetView : DBTopLevelView

/**
 Delegate that will be informed about tapping the widget. It needs to conform to `DBPerformanceWidgetViewDelegate` protocol.
 */
@property (nonatomic, weak) id <DBPerformanceWidgetViewDelegate> delegate;

/**
 An outlet to the label displaying current CPU usage.
 */
@property (nonatomic, strong) IBOutlet UILabel *cpuValueLabel;

/**
 An outlet to the label displaying current memory usage.
 */
@property (nonatomic, strong) IBOutlet UILabel *memoryValueLabel;

/**
 An outlet to the label displaying current frames per second value.
 */
@property (nonatomic, strong) IBOutlet UILabel *fpsValueLabel;

@end
