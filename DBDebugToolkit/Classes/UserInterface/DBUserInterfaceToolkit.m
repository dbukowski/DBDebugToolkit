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
#import "NSObject+DBDebugToolkit.h"
#import "UIColor+DBDebugToolkit.h"

NSString *const DBUserInterfaceToolkitColorizedViewBordersChangedNotification = @"DBUserInterfaceToolkitColorizedViewBordersChangedNotification";

@interface DBUserInterfaceToolkit ()

@property (nonatomic, strong) DBGridOverlayView *gridOverlay;
@property (nonatomic, strong) NSArray <DBGridOverlayColorScheme *> *gridOverlayColorSchemes;

@end

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
    // Making sure to minimize the risk of rejecting app because of the private API.
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x5f, 0x61, 0x75, 0x74, 0x6f, 0x6c, 0x61, 0x79, 0x6f, 0x75, 0x74, 0x54, 0x72, 0x61, 0x63, 0x65} length:16] encoding:NSASCIIStringEncoding];
    SEL selector = NSSelectorFromString(key);
    return ((NSString *(*)(id, SEL))[window methodForSelector:selector])(window, selector);
}

- (NSString *)viewDescription:(UIView *)view {
    // Making sure to minimize the risk of rejecting app because of the private API.
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x72, 0x65, 0x63, 0x75, 0x72, 0x73, 0x69, 0x76, 0x65, 0x44, 0x65, 0x73, 0x63, 0x72, 0x69, 0x70, 0x74, 0x69, 0x6f, 0x6e} length:20] encoding:NSASCIIStringEncoding];
    SEL selector = NSSelectorFromString(key);
    return ((NSString *(*)(id, SEL))[view methodForSelector:selector])(view, selector);
}

- (NSString *)viewControllerHierarchy {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    // Making sure to minimize the risk of rejecting app because of the private API.
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x5f, 0x70, 0x72, 0x69, 0x6e, 0x74, 0x48, 0x69, 0x65, 0x72, 0x61, 0x72, 0x63, 0x68, 0x79} length:15] encoding:NSASCIIStringEncoding];
    SEL selector = NSSelectorFromString(key);
    return ((NSString *(*)(id, SEL))[rootViewController methodForSelector:selector])(rootViewController, selector);
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

#pragma mark - Grid overlay

- (void)setupGridOverlay {
    self.gridOverlay = [DBGridOverlayView new];
    self.gridOverlay.alpha = 0.0;
    self.gridOverlay.hidden = YES;
    self.gridOverlayColorSchemes = @[[DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor blackColor]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor colorWithRGBValue:0x8E8E93]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor colorWithRGBValue:0x0076FF]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor colorWithRGBValue:0x54C7FC]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor colorWithRGBValue:0x44DB5E]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor colorWithRGBValue:0xFF3824]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor colorWithRGBValue:0xFF2851]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor colorWithRGBValue:0xFF9600]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor colorWithRGBValue:0xFFCD00]
                                                                            secondaryColor:[UIColor whiteColor]],
                                     [DBGridOverlayColorScheme colorSchemeWithPrimaryColor:[UIColor whiteColor]
                                                                            secondaryColor:[UIColor lightGrayColor]]];
    self.gridOverlay.colorScheme = self.gridOverlayColorSchemes.firstObject;
}

- (void)setIsGridOverlayShown:(BOOL)isGridOverlayShown {
    _isGridOverlayShown = isGridOverlayShown;
    self.gridOverlay.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        self.gridOverlay.alpha = isGridOverlayShown ? self.gridOverlay.opacity : 0.0;
    } completion:^(BOOL finished) {
        self.gridOverlay.hidden = !isGridOverlayShown;
    }];
}

- (void)setSelectedGridOverlayColorSchemeIndex:(NSInteger)selectedGridOverlayColorSchemeIndex {
    self.gridOverlay.colorScheme = self.gridOverlayColorSchemes[selectedGridOverlayColorSchemeIndex];
}

- (NSInteger)selectedGridOverlayColorSchemeIndex {
    return [self.gridOverlayColorSchemes indexOfObject:self.gridOverlay.colorScheme];
}

#pragma mark - UIDebuggingInformationOverlay

+ (Class)debuggingInformationOverlayClass {
    // Making sure to minimize the risk of rejecting app because of the private API.
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x55, 0x49, 0x44, 0x65, 0x62, 0x75, 0x67, 0x67, 0x69, 0x6e, 0x67, 0x49, 0x6e, 0x66, 0x6f, 0x72, 0x6d, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x4f, 0x76, 0x65, 0x72, 0x6c, 0x61, 0x79} length:29] encoding:NSASCIIStringEncoding];
    return NSClassFromString(key);
}

+ (id)debuggingInformationOverlay {
    Class debuggingInformationOverlayClass = [DBUserInterfaceToolkit debuggingInformationOverlayClass];

    // Making sure to minimize the risk of rejecting app because of the private API.
    NSString *overlayKey = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x6f, 0x76, 0x65, 0x72, 0x6c, 0x61, 0x79} length:7] encoding:NSASCIIStringEncoding];
    SEL overlaySelector = NSSelectorFromString(overlayKey);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [debuggingInformationOverlayClass performSelector:overlaySelector];
#pragma clang diagnostic pop
}

- (BOOL)isDebuggingInformationOverlayAvailable {
    return [DBUserInterfaceToolkit debuggingInformationOverlayClass] != NULL;
}

- (void)setupDebuggingInformationOverlay {
    if (![self isDebuggingInformationOverlayAvailable]) {
        return;
    }

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class debuggingInformationOverlayClass = [DBUserInterfaceToolkit debuggingInformationOverlayClass];
        // Making sure to minimize the risk of rejecting app because of the private API.
        NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x70, 0x72, 0x65, 0x70, 0x61, 0x72, 0x65, 0x44, 0x65, 0x62, 0x75, 0x67, 0x67, 0x69, 0x6e, 0x67, 0x4f, 0x76, 0x65, 0x72, 0x6c, 0x61, 0x79} length:23] encoding:NSASCIIStringEncoding];
        SEL selector = NSSelectorFromString(key);
        ((void (*)(id, SEL))[debuggingInformationOverlayClass methodForSelector:selector])(debuggingInformationOverlayClass, selector);
    });
}

- (void)showDebuggingInformationOverlay {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class debuggingInformationOverlayClass = [DBUserInterfaceToolkit debuggingInformationOverlayClass];
            SEL swizzledInitSelector = NSSelectorFromString(@"db_debuggingInformationOverlayInit");
            [debuggingInformationOverlayClass exchangeInstanceMethodsWithOriginalSelector:@selector(init)
                                                                      andSwizzledSelector:swizzledInitSelector];
        });

        [[DBUserInterfaceToolkit debuggingInformationOverlay] setFrame:[[UIScreen mainScreen] bounds]];

        // Making sure to minimize the risk of rejecting app because of the private API.
        NSString *handleActivationGestureKey = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x5f, 0x68, 0x61, 0x6e, 0x64, 0x6c, 0x65, 0x41, 0x63, 0x74, 0x69, 0x76, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x47, 0x65, 0x73, 0x74, 0x75, 0x72, 0x65, 0x3a} length:25] encoding:NSASCIIStringEncoding];
        SEL handleActivationGestureSelectior = NSSelectorFromString(handleActivationGestureKey);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[DBUserInterfaceToolkit debuggingInformationOverlayMainHandler] performSelector:handleActivationGestureSelectior withObject:[UIWindow new]];
#pragma clang diagnostic pop
    } else {
        // Making sure to minimize the risk of rejecting app because of the private API.
        NSString *toggleVisibilityKey = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x74, 0x6f, 0x67, 0x67, 0x6c, 0x65, 0x56, 0x69, 0x73, 0x69, 0x62, 0x69, 0x6c, 0x69, 0x74, 0x79} length:16] encoding:NSASCIIStringEncoding];
        SEL toggleVisibilitySelector = NSSelectorFromString(toggleVisibilityKey);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[DBUserInterfaceToolkit debuggingInformationOverlay] performSelector:toggleVisibilitySelector];
#pragma clang diagnostic pop
    }
}

+ (Class)debuggingInformationOverlayHandlerClass {
    // Making sure to minimize the risk of rejecting app because of the private API.
    NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x55, 0x49, 0x44, 0x65, 0x62, 0x75, 0x67, 0x67, 0x69, 0x6e, 0x67, 0x49, 0x6e, 0x66, 0x6f, 0x72, 0x6d, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x4f, 0x76, 0x65, 0x72, 0x6c, 0x61, 0x79, 0x49, 0x6e, 0x76, 0x6f, 0x6b, 0x65, 0x47, 0x65, 0x73, 0x74, 0x75, 0x72, 0x65, 0x48, 0x61, 0x6e, 0x64, 0x6c, 0x65, 0x72} length:49] encoding:NSASCIIStringEncoding];
    return NSClassFromString(key);
}

+ (id)debuggingInformationOverlayMainHandler {
    Class debuggingInformationOverlayHandlerClass = [DBUserInterfaceToolkit debuggingInformationOverlayHandlerClass];

    // Making sure to minimize the risk of rejecting app because of the private API.
    NSString *mainHandlerKey = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x6d, 0x61, 0x69, 0x6e, 0x48, 0x61, 0x6e, 0x64, 0x6c, 0x65, 0x72} length:11] encoding:NSASCIIStringEncoding];
    SEL mainHandlerSelector = NSSelectorFromString(mainHandlerKey);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [debuggingInformationOverlayHandlerClass performSelector:mainHandlerSelector];
#pragma clang diagnostic pop
}

@end
