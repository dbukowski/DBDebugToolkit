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

#import "DBTapTrigger.h"

static const NSUInteger DBTapTriggerDefaultNumberOfTapsRequired = 2;
static const NSUInteger DBTapTriggerDefaultNumberOfTouchesRequired = 2;

@interface DBTapTrigger ()

@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;

@end

@implementation DBTapTrigger

@synthesize delegate;

#pragma mark - Initialization

- (instancetype)init {
    return [self initWithNumberOfTapsRequired:DBTapTriggerDefaultNumberOfTapsRequired
                      numberOfTouchesRequired:DBTapTriggerDefaultNumberOfTouchesRequired];
}

- (instancetype)initWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                     numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired {
    self = [super init];
    if (self) {
        self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(gestureRecognizerAction:)];
        self.gestureRecognizer.numberOfTapsRequired = numberOfTapsRequired;
        self.gestureRecognizer.numberOfTouchesRequired = numberOfTouchesRequired;
    }
    
    return self;
}

+ (nonnull instancetype)trigger {
    return [[DBTapTrigger alloc] init];
}

+ (nonnull instancetype)triggerWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired {
    return [[DBTapTrigger alloc] initWithNumberOfTapsRequired:numberOfTapsRequired
                                      numberOfTouchesRequired:DBTapTriggerDefaultNumberOfTouchesRequired];
}

+ (nonnull instancetype)triggerWithNumberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired {
    return [[DBTapTrigger alloc] initWithNumberOfTapsRequired:DBTapTriggerDefaultNumberOfTapsRequired
                                      numberOfTouchesRequired:numberOfTouchesRequired];
}

+ (nonnull instancetype)triggerWithNumberOfTapsRequired:(NSUInteger)numberOfTapsRequired
                                numberOfTouchesRequired:(NSUInteger)numberOfTouchesRequired {
    return [[DBTapTrigger alloc] initWithNumberOfTapsRequired:numberOfTapsRequired
                                      numberOfTouchesRequired:numberOfTouchesRequired];
}

#pragma mark - Trigger properties

- (NSUInteger)numberOfTapsRequired {
    return self.gestureRecognizer.numberOfTapsRequired;
}

- (NSUInteger)numberOfTouchesRequired {
    return self.gestureRecognizer.numberOfTouchesRequired;
}

#pragma mark - Handling gesture recognizer

- (void)gestureRecognizerAction:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // numberOfTouchesRequired have tapped numberOfTapsRequired times.
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
