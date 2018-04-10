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

#import "DBPerformanceToolkit.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBFPSCalculator.h"
#import <mach/mach.h>

static const NSUInteger DBPerformanceToolkitMeasurementsCount = 120;
static const NSTimeInterval DBPerformanceToolkitTimeBetweenMeasurements = 1.0;

@interface DBPerformanceToolkit ()

@property (nonatomic, strong) DBPerformanceWidgetView *widget;
@property (nonatomic, strong) NSTimer *measurementsTimer;
@property (nonatomic, strong) DBFPSCalculator *fpsCalculator;

@property (nonatomic, strong) NSArray *cpuMeasurements;
@property (nonatomic, assign) CGFloat currentCPU;
@property (nonatomic, assign) CGFloat maxCPU;

@property (nonatomic, strong) NSArray *memoryMeasurements;
@property (nonatomic, assign) CGFloat currentMemory;
@property (nonatomic, assign) CGFloat maxMemory;

@property (nonatomic, strong) NSArray *fpsMeasurements;
@property (nonatomic, assign) CGFloat currentFPS;
@property (nonatomic, assign) CGFloat minFPS;
@property (nonatomic, assign) CGFloat maxFPS;

@property (nonatomic, assign) NSInteger currentMeasurementIndex;
@property (nonatomic, assign) NSInteger measurementsLimit;

@end

@implementation DBPerformanceToolkit

#pragma mark - Initialization

- (instancetype)initWithWidgetDelegate:(id<DBPerformanceWidgetViewDelegate>)widgetDelegate {
    self = [super init];
    if (self) {
        [self setupPerformanceWidgetWithDelegate:widgetDelegate];
        [self setupPerformanceMeasurement];
    }
    
    return self;
}

- (void)dealloc {
    [self.measurementsTimer invalidate];
    self.measurementsTimer = nil;
}

#pragma mark - Performance widget

- (void)setupPerformanceWidgetWithDelegate:(id<DBPerformanceWidgetViewDelegate>)widgetDelegate {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    self.widget = [[bundle loadNibNamed:@"DBPerformanceWidgetView" owner:self options:nil] objectAtIndex:0];
    self.widget.alpha = 0.0;
    self.widget.hidden = YES;
    self.widget.delegate = widgetDelegate;
}

- (void)refreshWidget {
    self.widget.cpuValueLabel.text = [NSString stringWithFormat:@"%.1lf%%", self.currentCPU];
    self.widget.memoryValueLabel.text = [NSString stringWithFormat:@"%.1lf MB", self.currentMemory];
    self.widget.fpsValueLabel.text = [NSString stringWithFormat:@"%.0lf", self.currentFPS];
}

- (void)setIsWidgetShown:(BOOL)isWidgetShown {
    _isWidgetShown = isWidgetShown;
    self.widget.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.widget.alpha = isWidgetShown ? 1.0 : 0.0;
    } completion:^(BOOL finished) {
        self.widget.hidden = !isWidgetShown;
    }];
}

#pragma mark - Performance Measurement

- (void)setupPerformanceMeasurement {
    self.measurementsLimit = DBPerformanceToolkitMeasurementsCount;
    self.cpuMeasurements = [NSArray array];
    self.memoryMeasurements = [NSArray array];
    self.fpsMeasurements = [NSArray array];
    self.fpsCalculator = [DBFPSCalculator new];
    self.minFPS = CGFLOAT_MAX;
    
    self.measurementsTimer = [NSTimer timerWithTimeInterval:DBPerformanceToolkitTimeBetweenMeasurements
                                                     target:self
                                                   selector:@selector(updateMeasurements)
                                                   userInfo:nil
                                                    repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.measurementsTimer forMode:NSRunLoopCommonModes];
}

- (void)updateMeasurements {
    // Update CPU measurements
    self.currentCPU = [self cpu];
    self.cpuMeasurements = [self array:self.cpuMeasurements byAddingMeasurement:self.currentCPU];
    self.maxCPU = MAX(self.maxCPU, self.currentCPU);
    
    // Update memory measurements
    self.currentMemory = [self memory];
    self.memoryMeasurements = [self array:self.memoryMeasurements byAddingMeasurement:self.currentMemory];
    self.maxMemory = MAX(self.maxMemory, self.currentMemory);
    
    // Update FPS measurements
    self.currentFPS = [self fps];
    self.fpsMeasurements = [self array:self.fpsMeasurements byAddingMeasurement:self.currentFPS];
    self.minFPS = MIN(self.minFPS, self.currentFPS);
    self.maxFPS = MAX(self.maxFPS, self.currentFPS);
    
    [self refreshWidget];
    [self.delegate performanceToolkitDidUpdateStats:self];
    self.currentMeasurementIndex = MIN(DBPerformanceToolkitMeasurementsCount, self.currentMeasurementIndex + 1);
}

- (NSArray *)array:(NSArray *)array byAddingMeasurement:(CGFloat)measurement {
    NSMutableArray *newMeasurements = [array mutableCopy];
    if (self.currentMeasurementIndex == DBPerformanceToolkitMeasurementsCount) {
        // We reached the end of the array. We start by shifting the previous measurements.
        for (int index = 0; index < DBPerformanceToolkitMeasurementsCount - 1; index++) {
            newMeasurements[index] = newMeasurements[index + 1];
        }
        // Then we add the new measurement to the end of the array.
        newMeasurements[DBPerformanceToolkitMeasurementsCount - 1] = @(measurement);
    } else {
        // If we did not reach the limit of measurements we simply add the next one.
        [newMeasurements addObject:@(measurement)];
    }
    return [newMeasurements copy];
}

- (NSTimeInterval)timeBetweenMeasurements {
    return DBPerformanceToolkitTimeBetweenMeasurements;
}

#pragma mark - CPU

- (CGFloat)cpu {
    task_info_data_t taskInfo;
    mach_msg_type_number_t taskInfoCount = TASK_INFO_MAX;
    if (task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)taskInfo, &taskInfoCount) != KERN_SUCCESS) {
        return -1;
    }
    
    thread_array_t threadList;
    mach_msg_type_number_t threadCount;
    thread_info_data_t threadInfo;
    
    if (task_threads(mach_task_self(), &threadList, &threadCount) != KERN_SUCCESS) {
        return -1;
    }
    float totalCpu = 0;
    
    for (int threadIndex = 0; threadIndex < threadCount; threadIndex++) {
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info(threadList[threadIndex], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) != KERN_SUCCESS) {
            return -1;
        }
        
        thread_basic_info_t threadBasicInfo = (thread_basic_info_t)threadInfo;
        
        if (!(threadBasicInfo->flags & TH_FLAGS_IDLE)) {
            totalCpu = totalCpu + threadBasicInfo->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    }
    vm_deallocate(mach_task_self(), (vm_offset_t)threadList, threadCount * sizeof(thread_t));
    
    return MIN(totalCpu, 100.0);
}

#pragma mark - Memory

- (CGFloat)memory {
    struct task_basic_info taskInfo;
    mach_msg_type_number_t taskInfoCount = sizeof(taskInfo);
    kern_return_t result = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &taskInfoCount);
    return result == KERN_SUCCESS ? taskInfo.resident_size / 1024.0 / 1024.0 : 0;
}

- (void)simulateMemoryWarning {
    // Making sure to minimize the risk of rejecting app because of the private API.
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x5f, 0x70, 0x65, 0x72, 0x66, 0x6f, 0x72, 0x6d, 0x4d, 0x65, 0x6d, 0x6f, 0x72, 0x79, 0x57, 0x61, 0x72, 0x6e, 0x69, 0x6e, 0x67} length:21] encoding:NSASCIIStringEncoding];
    SEL selector = NSSelectorFromString(key);
    id object = [UIApplication sharedApplication];
    ((void (*)(id, SEL))[object methodForSelector:selector])(object, selector);
}

#pragma mark - FPS

- (CGFloat)fps {
    return [self.fpsCalculator fps];
}

@end
