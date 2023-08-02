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

#import "DBLongPressTrigger.h"

static const NSUInteger DBLongPressTriggerDefaultNumberOfTouchesRequired = 2;
static const NSTimeInterval DBLongPressTriggerDefaultMinimumPressDuration = 0.5;

@interface DBLongPressTrigger ()

@property (nonatomic, strong) UILongPressGestureRecognizer *gestureRecognizer;

@end

@implementation DBLongPressTrigger

@synthesize delegate;

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithNumberOfTouchesRequired:DBLongPressTriggerDefaultNumberOfTouchesRequired
                            minimumPressDuration:DBLongPressTriggerDefaultMinimumPressDuration];
}

- (instancetype)initWithNumberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
                           minimumPressDuration:(NSTimeInterval)minimumPressDuration {
    self = [super init];
    if (self) {
        self.gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(gestureRecognizerAction:)];
        self.gestureRecognizer.numberOfTouchesRequired = numberOfTouchesRequired;
        self.gestureRecognizer.minimumPressDuration = minimumPressDuration;
    }
    
    return self;
}

+ (nonnull instancetype)trigger {
    return [[self alloc] init];
}

+ (nonnull instancetype)triggerWithNumberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired {
    return [[self alloc] initWithNumberOfTouchesRequired:numberOfTouchesRequired
                                    minimumPressDuration:DBLongPressTriggerDefaultMinimumPressDuration];
}

+ (nonnull instancetype)triggerWithMinimumPressDuration:(NSTimeInterval)minimumPressDuration {
    return [[self alloc] initWithNumberOfTouchesRequired:DBLongPressTriggerDefaultNumberOfTouchesRequired
                                    minimumPressDuration:minimumPressDuration];
}

+ (nonnull instancetype)triggerWithNumberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired
                                      minimumPressDuration:(NSTimeInterval)minimumPressDuration {
    return [[self alloc] initWithNumberOfTouchesRequired:numberOfTouchesRequired
                                    minimumPressDuration:minimumPressDuration];
}

#pragma mark - Trigger properties

- (NSUInteger)numberOfTouchesRequired {
    return self.gestureRecognizer.numberOfTouchesRequired;
}

- (NSTimeInterval)minimumPressDuration {
    return self.gestureRecognizer.minimumPressDuration;
}

#pragma mark - Handling gesture recognizer

- (void)gestureRecognizerAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        // numberOfTouchesRequired have tapped and been held for minumPressDuration.
        [self.delegate debugToolkitTriggered:self];
    }
}

#pragma mark - DBDebugToolkitTrigger

- (void)addToWindow:(UIWindow *)window {
    [window addGestureRecognizer:self.gestureRecognizer];
}

- (void)removeFromWindow:(UIWindow *)window {
    [window removeGestureRecognizer:self.gestureRecognizer];
}

@end
