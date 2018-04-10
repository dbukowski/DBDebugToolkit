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

#import "UIWindow+DBUserInterfaceToolkit.h"
#import "DBTouchIndicatorView.h"
#import <objc/runtime.h>
#import "NSObject+DBDebugToolkit.h"
#import "DBUserInterfaceToolkit.h"

static NSString *const UIWindowTouchIndicatorsKey = @"DBDebugToolkit_touchIndicators";
static NSString *const UIWindowReusableTouchIndicatorsKey = @"DBDebugToolkit_reusableTouchIndicators";
static const CGFloat UIWindowTouchIndicatorViewMinAlpha = 0.6;

@interface UIWindow (DBUserInterfaceToolkitPrivate)

@property (nonatomic) NSMapTable <UITouch *, DBTouchIndicatorView *> *touchIndicators;
@property (nonatomic) NSMutableSet <DBTouchIndicatorView *> *reusableTouchIndicators;

@end

@implementation UIWindow (DBUserInterfaceToolkitPrivate)

#pragma mark - TouchIndicators property

- (NSMapTable <UITouch *, DBTouchIndicatorView *> *)touchIndicators {
    NSMapTable <UITouch *, DBTouchIndicatorView *> *touchIndicators = objc_getAssociatedObject(self, (__bridge const void*)UIWindowTouchIndicatorsKey);
    if (!touchIndicators) {
        touchIndicators = [NSMapTable weakToWeakObjectsMapTable];
        [self setTouchIndicators:touchIndicators];
    }
    return touchIndicators;
}

- (void)setTouchIndicators:(NSMapTable <UITouch *, DBTouchIndicatorView *> *)touchIndicators {
    objc_setAssociatedObject(self, (__bridge const void*)UIWindowTouchIndicatorsKey, touchIndicators, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - ReusableTouchIndicators property

- (NSMutableSet <DBTouchIndicatorView *> *)reusableTouchIndicators {
    NSMutableSet <DBTouchIndicatorView *> *reusableTouchIndicators = objc_getAssociatedObject(self, (__bridge const void*)UIWindowReusableTouchIndicatorsKey);
    if (!reusableTouchIndicators) {
        reusableTouchIndicators = [NSMutableSet set];
        [self setReusableTouchIndicators:reusableTouchIndicators];
    }
    return reusableTouchIndicators;
}

- (void)setReusableTouchIndicators:(NSMutableSet <DBTouchIndicatorView *> *)reusableTouchIndicators {
    objc_setAssociatedObject(self, (__bridge const void*)UIWindowReusableTouchIndicatorsKey, reusableTouchIndicators, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIWindow (DBUserInterfaceToolkit)

#pragma mark - Method swizzling

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block IMP originalIMP = [self replaceMethodWithSelector:@selector(sendEvent:)
                                                            block:^(UIWindow *blockSelf, UIEvent *event) {
                                                                if (event.type == UIEventTypeTouches) {
                                                                    [blockSelf db_handleTouches:event.allTouches];
                                                                }
                                                                ((void (*)(id, SEL, UIEvent *))originalIMP)(blockSelf, @selector(sendEvent:), event);
                                                            }];
    });
}

#pragma mark - Handling showing touches

- (void)setShowingTouchesEnabled:(BOOL)enabled {
    NSEnumerator *enumerator = [self.touchIndicators objectEnumerator];
    DBTouchIndicatorView *touchIndicatorView;
    while (touchIndicatorView = [enumerator nextObject]) {
        touchIndicatorView.hidden = !enabled;
    }
    for (DBTouchIndicatorView *touchIndicatorView in self.reusableTouchIndicators) {
        touchIndicatorView.hidden = !enabled;
    }
}

- (void)db_handleTouches:(NSSet<UITouch *> *)touches {
    for (UITouch *touch in touches) {
        [self db_handleTouch:touch];
    }
}

- (void)db_handleTouch:(UITouch *)touch {
    switch (touch.phase) {
        case UITouchPhaseBegan:
            [self db_addTouchIndicatorWithTouch:touch];
            break;
        case UITouchPhaseMoved:
            [self db_moveTouchIndicatorWithTouch:touch];
            break;
        case UITouchPhaseEnded:
        case UITouchPhaseCancelled:
            [self db_removeTouchIndicatorWithTouch:touch];
        default:
            return;
    }
}

- (void)db_addTouchIndicatorWithTouch:(UITouch *)touch {
    DBTouchIndicatorView *indicatorView = [self db_availableTouchIndicatorView];
    indicatorView.hidden = ![DBUserInterfaceToolkit sharedInstance].showingTouchesEnabled;
    [self.touchIndicators setObject:indicatorView forKey:touch];
    [self addSubview:indicatorView];
    indicatorView.center = [touch locationInView:self];
    [self db_handleTouchForce:touch];
}

- (DBTouchIndicatorView *)db_availableTouchIndicatorView {
    DBTouchIndicatorView *indicatorView = [self.reusableTouchIndicators anyObject];
    if (indicatorView == nil) {
        indicatorView = [DBTouchIndicatorView indicatorView];
    } else {
        [self.reusableTouchIndicators removeObject:indicatorView];
    }
    return indicatorView;
}

- (void)db_moveTouchIndicatorWithTouch:(UITouch *)touch {
    DBTouchIndicatorView *indicatorView = [self.touchIndicators objectForKey:touch];
    indicatorView.center = [touch locationInView:self];
    [self db_handleTouchForce:touch];
}

- (void)db_removeTouchIndicatorWithTouch:(UITouch *)touch {
    DBTouchIndicatorView *indicatorView = [self.touchIndicators objectForKey:touch];
    if (indicatorView) {
        [indicatorView removeFromSuperview];
        [self.touchIndicators removeObjectForKey:touch];
        [self.reusableTouchIndicators addObject:indicatorView];
    }
}

- (void)db_handleTouchForce:(UITouch *)touch {
    DBTouchIndicatorView *indicatorView = [self.touchIndicators objectForKey:touch];
    CGFloat indicatorViewAlpha = 1.0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)] && self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        indicatorViewAlpha = UIWindowTouchIndicatorViewMinAlpha + (1.0 - UIWindowTouchIndicatorViewMinAlpha) * touch.force / touch.maximumPossibleForce;
    }
#pragma clang diagnostic pop
    indicatorView.alpha = indicatorViewAlpha;
}

#pragma mark - UIDebuggingInformationOverlay

- (instancetype)db_debuggingInformationOverlayInit {
    return [super init];
}

- (UIGestureRecognizerState)state {
    return UIGestureRecognizerStateEnded;
}

@end
