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

//#define PERFORMANCE_TOOLKIT_ENFORCE_THREAD_SAFETY 1

#import "DBPerformanceToolkit.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBFPSCalculator.h"
#import <mach/mach.h>

static const NSUInteger DBPerformanceToolkitMeasurementsCount = 120;
const NSTimeInterval DBPerformanceToolkitTimeBetweenMeasurements = 1.0;

@interface DBPerformanceToolkit ()

#if PERFORMANCE_TOOLKIT_ENFORCE_THREAD_SAFETY
@property (nonatomic, strong) dispatch_queue_t dataAccessQueue;
#endif

@property (nonatomic, strong) dispatch_queue_t measurementsTimerQueue;
@property (nonatomic, strong) dispatch_source_t measurementsTimer;

@property (nonatomic, strong) DBPerformanceWidgetView *widget;
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
//	dispatch_
    self.measurementsTimer = nil;
}

#pragma mark - Performance widget

- (void)setupPerformanceWidgetWithDelegate:(id<DBPerformanceWidgetViewDelegate>)widgetDelegate {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    self.widget = [[bundle loadNibNamed:@"DBPerformanceWidgetView" owner:self options:nil] objectAtIndex:0];
    self.widget.alpha = 0.0;
    self.widget.delegate = widgetDelegate;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self addWidgetToWindow:keyWindow];
}

- (void)refreshWidget {
	self.widget.cpuValueTextLayer.string = [NSString stringWithFormat:@"%.1lf%%", _currentCPU];
	self.widget.memoryValueTextLayer.string = [NSString stringWithFormat:@"%.1lf MB", _currentMemory];
	self.widget.fpsValueTextLayer.string = [NSString stringWithFormat:@"%.0lf", _currentFPS];
	[self.widget.cpuValueTextLayer display];
	[CATransaction flush];
}

- (void)setIsWidgetShown:(BOOL)isWidgetShown {
    _isWidgetShown = isWidgetShown;
    [UIView animateWithDuration:0.35 animations:^{
        self.widget.alpha = isWidgetShown ? 1.0 : 0.0;
    }];
}

- (void)addWidgetToWindow:(UIWindow *)window {
    [window addSubview:self.widget];
    // We observe the "layer.sublayers" property of the window to keep the widget on top.
    [window addObserver:self
             forKeyPath:@"layer.sublayers"
                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                context:nil];
}

- (void)updateKeyWindow:(UIWindow *)window {
    [self addWidgetToWindow:window];
}

- (void)windowDidResignKey:(UIWindow *)window {
    [window removeObserver:self forKeyPath:@"layer.sublayers"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // We want to keep the widget on top of all the views.
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow bringSubviewToFront:self.widget];
}

#pragma mark - Performance Measurement

- (void)setupPerformanceMeasurement {
#if PERFORMANCE_TOOLKIT_ENFORCE_THREAD_SAFETY
	self.dataAccessQueue = dispatch_queue_create("dataAccessQueue", DISPATCH_QUEUE_SERIAL);
#endif
	
    self.measurementsLimit = DBPerformanceToolkitMeasurementsCount;
    self.cpuMeasurements = [NSArray array];
    self.memoryMeasurements = [NSArray array];
    self.fpsMeasurements = [NSArray array];
    self.fpsCalculator = [DBFPSCalculator new];
    self.minFPS = CGFLOAT_MAX;

	dispatch_queue_attr_t qosAttribute = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0);
	self.measurementsTimerQueue = dispatch_queue_create("measurementsTimerQueue", qosAttribute);

	self.measurementsTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.measurementsTimerQueue);
	uint64_t interval = DBPerformanceToolkitTimeBetweenMeasurements * NSEC_PER_SEC;
	dispatch_source_set_timer(self.measurementsTimer, dispatch_walltime(NULL, 0), interval, interval / 10);
	__weak __typeof(self) weakSelf = self;
	
	dispatch_source_set_event_handler(self.measurementsTimer, ^{
		[weakSelf updateMeasurements];
	});
	
	dispatch_resume(self.measurementsTimer);
}

- (void)updateMeasurements {
#if PERFORMANCE_TOOLKIT_ENFORCE_THREAD_SAFETY
	dispatch_sync(self.dataAccessQueue, ^{
#endif
		// Update CPU measurements
		self.currentCPU = [self cpu];
		self.cpuMeasurements = [self array:_cpuMeasurements byAddingMeasurement:_currentCPU];
		self.maxCPU = MAX(_maxCPU, _currentCPU);
		
		// Update memory measurements
		self.currentMemory = [self memory];
		self.memoryMeasurements = [self array:_memoryMeasurements byAddingMeasurement:_currentMemory];
		self.maxMemory = MAX(_maxMemory, _currentMemory);
		
		// Update FPS measurements
		self.currentFPS = [self fps];
		self.fpsMeasurements = [self array:_fpsMeasurements byAddingMeasurement:_currentFPS];
		self.minFPS = MIN(_minFPS, _currentFPS);
		self.maxFPS = MAX(_maxFPS, _currentFPS);
		
		[self refreshWidget];
		self.currentMeasurementIndex = MIN(DBPerformanceToolkitMeasurementsCount, self.currentMeasurementIndex + 1);
#if PERFORMANCE_TOOLKIT_ENFORCE_THREAD_SAFETY
	});
#endif
	[self.delegate performanceToolkitDidUpdateStats:self];
}

#if PERFORMANCE_TOOLKIT_ENFORCE_THREAD_SAFETY
#define THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(__name__, __type__) - (__type__)__name__ {\
	__block __type__ rv;\
	dispatch_sync(self.dataAccessQueue, ^{\
		rv = _##__name__;\
	});\
	return rv;\
}

THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(cpuMeasurements, NSArray*);
THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(currentCPU, CGFloat);
THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(maxCPU, CGFloat);

THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(memoryMeasurements, NSArray*);
THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(currentMemory, CGFloat);
THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(maxMemory, CGFloat);

THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(fpsMeasurements, NSArray*);
THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(currentFPS, CGFloat);
THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(minFPS, CGFloat);
THREAD_SAFE_PROPERTY_ACCESSOR_MACRO(maxFPS, CGFloat);

#undef THREAD_SAFE_PROPERTY_ACCESSOR_MACRO
#endif

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
	NSAssert([NSThread isMainThread], @"Must be called on main thread.");
	
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
