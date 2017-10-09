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

#define FPS_CALCULATOR_ENFORCE_THREAD_SAFETY 1

#import "DBFPSCalculator.h"

@import Darwin;

static const CGFloat DBFPSCalculatorTargetFramerate = 60.0;
extern const NSTimeInterval DBPerformanceToolkitTimeBetweenMeasurements;

@interface DBFPSCalculator ()

@property (nonatomic, strong) CADisplayLink *displayLink;

//Holds
@property (nonatomic, assign) uint32_t frameCount;

//Background polling timer
@property (nonatomic, strong) dispatch_queue_t fpsPollingQueue;
@property (nonatomic, strong) dispatch_source_t backgroundTimer;

//Handle last known fps - must use synchronized access for thread safety
#if FPS_CALCULATOR_ENFORCE_THREAD_SAFETY
@property (nonatomic, strong) dispatch_queue_t lastKnownFPSQueue;
#endif
@property (nonatomic, assign) CGFloat lastKnownFPS;

@end

@implementation DBFPSCalculator

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupFPSMonitoring];
        [self setupNotifications];
    }
    
    return self;
}

- (void)dealloc {
    [self.displayLink setPaused:YES];
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - FPS Monitoring

- (void)setupFPSMonitoring {
	dispatch_queue_attr_t qosAttribute = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INTERACTIVE, 0);
	self.fpsPollingQueue = dispatch_queue_create("fpsPollingQueue", qosAttribute);
#if FPS_CALCULATOR_ENFORCE_THREAD_SAFETY
	self.lastKnownFPSQueue = dispatch_queue_create("lastKnownFPSQueue", DISPATCH_QUEUE_SERIAL);
#endif
	
	self.backgroundTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.fpsPollingQueue);
	uint64_t interval = DBPerformanceToolkitTimeBetweenMeasurements * NSEC_PER_SEC;
	dispatch_source_set_timer(self.backgroundTimer, dispatch_walltime(NULL, 0), interval, interval / 10);
	
	__weak __typeof(self) weakSelf = self;
	
	dispatch_source_set_event_handler(self.backgroundTimer, ^{
		__strong __typeof(weakSelf) strongSelf = weakSelf;
		if(strongSelf == nil)
		{
			return;
		}
		
#if FPS_CALCULATOR_ENFORCE_THREAD_SAFETY
		uint32_t frameCount = OSAtomicXor32Orig(strongSelf->_frameCount, &strongSelf->_frameCount);
#else
		uint32_t frameCount = strongSelf->_frameCount;
		strongSelf->_frameCount = 0;
#endif
		CGFloat fps = MIN(frameCount / DBPerformanceToolkitTimeBetweenMeasurements, DBFPSCalculatorTargetFramerate);

#if FPS_CALCULATOR_ENFORCE_THREAD_SAFETY
		dispatch_sync(strongSelf.lastKnownFPSQueue, ^{
#endif
			strongSelf.lastKnownFPS = fps;
#if FPS_CALCULATOR_ENFORCE_THREAD_SAFETY
		});
#endif
	});
	
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	
	if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
	{
		dispatch_resume(self.backgroundTimer);
	}
	else
	{
		[self.displayLink setPaused:YES];
	}
}

- (void)displayLinkTick {
#if FPS_CALCULATOR_ENFORCE_THREAD_SAFETY
	OSAtomicIncrement32((int32_t*)&_frameCount);
#else
	_frameCount++;
#endif
}

#pragma mark - Notifications

- (void)setupNotifications {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(applicationDidBecomeActiveNotification:)
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(applicationWillResignActiveNotification:)
                                                 name: UIApplicationWillResignActiveNotification
                                               object: nil];
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification {
	self.frameCount = 0;
    [self.displayLink setPaused:NO];
	dispatch_resume(self.backgroundTimer);
}


- (void)applicationWillResignActiveNotification:(NSNotification *)notification {
    [self.displayLink setPaused:YES];
	dispatch_suspend(self.backgroundTimer);
}

#pragma mark - FPS 

- (CGFloat)fps {
	__block CGFloat fps;
	
#if FPS_CALCULATOR_ENFORCE_THREAD_SAFETY
	dispatch_sync(_lastKnownFPSQueue, ^{
#endif
		fps = self.lastKnownFPS;
#if FPS_CALCULATOR_ENFORCE_THREAD_SAFETY
	});
#endif
	
	return fps;
}

@end
