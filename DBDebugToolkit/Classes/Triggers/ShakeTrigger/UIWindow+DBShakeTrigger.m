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

#import <objc/runtime.h>
#import "UIWindow+DBShakeTrigger.h"
#import "NSObject+DBDebugToolkit.h"

static NSString *const UIWindowShakeDelegatesKey = @"DBDebugToolkit_shakeDelegates";

@interface UIWindow (DBShakeTriggerPrivate)

@property (nonatomic) NSArray <id <UIWindowShakeDelegate>> *shakeDelegates;

@end

@implementation UIWindow (DBShakeTriggerPrivate)

#pragma mark - ShakeTriggers property

- (void)setShakeDelegates:(NSArray<id<UIWindowShakeDelegate>> *)shakeDelegates {
    objc_setAssociatedObject(self, (__bridge const void*)UIWindowShakeDelegatesKey, shakeDelegates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray <id <UIWindowShakeDelegate>> *)shakeDelegates {
    NSArray *shakeDelegates = objc_getAssociatedObject(self, (__bridge const void*)UIWindowShakeDelegatesKey);
    if (!shakeDelegates) {
        shakeDelegates = [NSArray new];
        [self setShakeDelegates:shakeDelegates];
    }
    return shakeDelegates;
}

@end

@implementation UIWindow (DBShakeTrigger)

#pragma mark - Category methods

- (void)addShakeDelegate:(id<UIWindowShakeDelegate>)shakeDelegate {
    NSMutableArray <id <UIWindowShakeDelegate>> *newShakeDelegates = [self.shakeDelegates mutableCopy];
    [newShakeDelegates addObject:shakeDelegate];
    self.shakeDelegates = [newShakeDelegates copy];
}

- (void)removeShakeDelegate:(id<UIWindowShakeDelegate>)shakeDelegate {
    NSMutableArray <id <UIWindowShakeDelegate>> *newShakeDelegates = [self.shakeDelegates mutableCopy];
    [newShakeDelegates removeObject:shakeDelegate];
    self.shakeDelegates = [newShakeDelegates copy];
}

#pragma mark - Recognizing shake motion

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Adding informing delegates about shake motion to the original implementation.
        __block IMP originalIMP = [self replaceMethodWithSelector:@selector(motionEnded:withEvent:)
                                                            block:^(UIWindow *blockSelf, UIEventSubtype motion, UIEvent *event) {
                                                                if (motion == UIEventSubtypeMotionShake) {
                                                                    [blockSelf.shakeDelegates makeObjectsPerformSelector:@selector(windowDidEndShakeMotion:) withObject:self];
                                                                }
                                                                ((void (*)(id, SEL, UIEventSubtype, UIEvent *))originalIMP)(blockSelf, @selector(motionEnded:withEvent:), motion, event);
                                                            }];
    });
}

@end
