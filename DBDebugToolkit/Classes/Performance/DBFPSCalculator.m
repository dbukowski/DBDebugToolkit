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

#import "DBFPSCalculator.h"

static const NSUInteger DBFPSCalculatorSamplesCount = 60;

@interface DBFPSCalculator ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval lastDisplayLinkTickTime;
@property (nonatomic, strong) NSMutableArray *tickTimes;
@property (nonatomic, assign) NSUInteger nextTickTimeIndex;
@property (nonatomic, assign) CFTimeInterval storedTickTimesSum;

@end

@implementation DBFPSCalculator

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDisplayLink];
        [self setupNotifications];
    }
    
    return self;
}

- (void)dealloc {
    [self.displayLink setPaused:YES];
    [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - Display Link

- (void)setupDisplayLink {
    self.lastDisplayLinkTickTime = CACurrentMediaTime();
    self.tickTimes = [NSMutableArray array];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
    [self.displayLink setPaused:YES];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)displayLinkTick {
    CFTimeInterval tickTime = self.displayLink.timestamp - self.lastDisplayLinkTickTime;
    self.storedTickTimesSum += tickTime;
    if (self.nextTickTimeIndex == self.tickTimes.count) {
        [self.tickTimes addObject:@(tickTime)];
    } else {
        self.storedTickTimesSum -= [self.tickTimes[self.nextTickTimeIndex] doubleValue];
        self.tickTimes[self.nextTickTimeIndex] = @(tickTime);
    }
    self.nextTickTimeIndex = (self.nextTickTimeIndex == DBFPSCalculatorSamplesCount - 1) ? 0 : (self.nextTickTimeIndex + 1);
    self.lastDisplayLinkTickTime = self.displayLink.timestamp;
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
    self.lastDisplayLinkTickTime = CACurrentMediaTime(); // Don't include the inactive time.
    [self.displayLink setPaused:NO];
}


- (void)applicationWillResignActiveNotification:(NSNotification *)notification {
    [self.displayLink setPaused:YES];
}

#pragma mark - FPS 

- (CGFloat)fps {
    if (self.tickTimes.count == 0) {
        return -1;
    }
    
    // storedTickTimesSum should be equal to the sum of tickTimes array elements.
    CGFloat meanTickTime = self.storedTickTimesSum / self.tickTimes.count;
    return 1.0 / meanTickTime;
}

@end
