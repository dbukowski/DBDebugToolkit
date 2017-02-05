//
//  UIWindow+DBUserInterfaceToolkit.m
//  Pods
//
//  Created by Dariusz Bukowski on 05.02.2017.
//
//

#import "UIWindow+DBUserInterfaceToolkit.h"
#import "DBTouchIndicatorView.h"
#import <objc/runtime.h>
#import "NSObject+DBDebugToolkit.h"
#import "DBUserInterfaceToolkit.h"

static NSString *const UIWindowTouchIndicatorsKey = @"DBDebugToolkit_touchIndicators";
static NSString *const UIWindowReusableTouchIndicatorsKey = @"DBDebugToolkit_reusableTouchIndicators";

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
    [UIView animateWithDuration:0.35 animations:^{
        NSEnumerator *enumerator = [self.touchIndicators objectEnumerator];
        DBTouchIndicatorView *touchIndicatorView;
        while (touchIndicatorView = [enumerator nextObject]) {
            touchIndicatorView.alpha = enabled ? 1.0 : 0.0;
        }
        for (DBTouchIndicatorView *touchIndicatorView in self.reusableTouchIndicators) {
            touchIndicatorView.alpha = enabled ? 1.0 : 0.0;
        }
    }];
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
    indicatorView.alpha = [DBUserInterfaceToolkit sharedInstance].showingTouchesEnabled ? 1.0 : 0.0;
    [self.touchIndicators setObject:indicatorView forKey:touch];
    [self addSubview:indicatorView];
    indicatorView.center = [touch locationInView:self];
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
}

- (void)db_removeTouchIndicatorWithTouch:(UITouch *)touch {
    DBTouchIndicatorView *indicatorView = [self.touchIndicators objectForKey:touch];
    [indicatorView removeFromSuperview];
    [self.touchIndicators removeObjectForKey:touch];
    [self.reusableTouchIndicators addObject:indicatorView];
}

@end
