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

#import "DBUserInterfaceToolkit.h"
#import "UIView+DBUserInterfaceToolkit.h"
#import "UIWindow+DBUserInterfaceToolkit.h"

NSString *const DBUserInterfaceToolkitColorizedViewBordersChangedNotification = @"DBUserInterfaceToolkitColorizedViewBordersChangedNotification";

@implementation DBUserInterfaceToolkit

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static DBUserInterfaceToolkit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBUserInterfaceToolkit alloc] init];
        [sharedInstance registerForNotifications];
    });
    return sharedInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Window notifications

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newKeyWindowNotification:)
                                                 name:UIWindowDidBecomeKeyNotification
                                               object:nil];
}

- (void)newKeyWindowNotification:(NSNotification *)notification {
    UIWindow *newKeyWindow = notification.object;
    [self setSpeedForWindow:newKeyWindow];
    [self setShowingTouchesEnabledForWindow:newKeyWindow];
}

#pragma mark - Public methods

- (NSString *)autolayoutTrace {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    return [window performSelector:@selector(_autolayoutTrace)];
#pragma clang diagnostic pop
}

- (NSString *)viewDescription:(UIView *)view {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    return [view performSelector:@selector(recursiveDescription)];
#pragma clang diagnostic pop
}

- (NSString *)viewControllerHierarchy {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    return [rootViewController performSelector:@selector(_printHierarchy)];
#pragma clang diagnostic pop
}

- (NSString *)fontFamilies {
    NSMutableArray *fontFamilyDescriptions = [NSMutableArray array];
    NSArray *sortedFontFamilyNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *fontFamilyName in sortedFontFamilyNames) {
        NSMutableArray *fontDescriptions = [NSMutableArray array];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamilyName];
        NSArray *sortedFontNames = [fontNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for (NSString *fontName in sortedFontNames) {
            [fontDescriptions addObject:[NSString stringWithFormat:@"\t- %@", fontName]];
        }
        NSString *fontDescriptionsString = [fontDescriptions componentsJoinedByString:@"\n"];
        [fontFamilyDescriptions addObject:[NSString stringWithFormat:@" • %@:\n%@", fontFamilyName, fontDescriptionsString]];
    }
    return [fontFamilyDescriptions componentsJoinedByString:@"\n\n"];
}

#pragma mark - Handling flags 

- (void)setSlowAnimationsEnabled:(BOOL)slowAnimationsEnabled {
    if (_slowAnimationsEnabled != slowAnimationsEnabled) {
        _slowAnimationsEnabled = slowAnimationsEnabled;
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            [self setSpeedForWindow:window];
        }
    }
}

- (void)setSpeedForWindow:(UIWindow *)window {
    float speed = self.slowAnimationsEnabled ? 0.1 : 1.0;
    window.layer.speed = speed;
}

- (void)setColorizedViewBordersEnabled:(BOOL)colorizedViewBordersEnabled {
    if (_colorizedViewBordersEnabled != colorizedViewBordersEnabled) {
        _colorizedViewBordersEnabled = colorizedViewBordersEnabled;
        [[NSNotificationCenter defaultCenter] postNotificationName:DBUserInterfaceToolkitColorizedViewBordersChangedNotification
                                                            object:@(colorizedViewBordersEnabled)];
    }
}

- (void)setShowingTouchesEnabled:(BOOL)showingTouchesEnabled {
    if (_showingTouchesEnabled != showingTouchesEnabled) {
        _showingTouchesEnabled = showingTouchesEnabled;
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            [self setShowingTouchesEnabledForWindow:window];
        }
    }
}

- (void)setShowingTouchesEnabledForWindow:(UIWindow *)window {
    [window setShowingTouchesEnabled:self.showingTouchesEnabled];
}

@end
