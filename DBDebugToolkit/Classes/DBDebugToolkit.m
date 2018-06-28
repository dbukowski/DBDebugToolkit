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

#import "DBDebugToolkit.h"
#import "DBShakeTrigger.h"
#import "DBMenuTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBPerformanceWidgetView.h"
#import "DBPerformanceToolkit.h"
#import "DBPerformanceTableViewController.h"
#import "DBConsoleOutputCaptor.h"
#import "DBNetworkToolkit.h"
#import "DBUserInterfaceToolkit.h"
#import "DBLocationToolkit.h"
#import "DBKeychainToolkit.h"
#import "DBUserDefaultsToolkit.h"
#import "DBCoreDataToolkit.h"
#import "DBCrashReportsToolkit.h"
#import "DBTopLevelViewsWrapper.h"
#import "UIApplication+DBDebugToolkit.h"

static NSString *const DBDebugToolkitObserverPresentationControllerPropertyKeyPath = @"containerView";

@interface DBDebugToolkit () <DBDebugToolkitTriggerDelegate, DBMenuTableViewControllerDelegate, DBPerformanceWidgetViewDelegate>

@property (nonatomic, copy) NSArray <id <DBDebugToolkitTrigger>> *triggers;
@property (nonatomic, strong) DBMenuTableViewController *menuViewController;
@property (nonatomic, assign) BOOL showsMenu;
@property (nonatomic, strong) DBPerformanceToolkit *performanceToolkit;
@property (nonatomic, strong) DBConsoleOutputCaptor *consoleOutputCaptor;
@property (nonatomic, strong) DBNetworkToolkit *networkToolkit;
@property (nonatomic, strong) DBUserInterfaceToolkit *userInterfaceToolkit;
@property (nonatomic, strong) DBLocationToolkit *locationToolkit;
@property (nonatomic, strong) DBCoreDataToolkit *coreDataToolkit;
@property (nonatomic, strong) DBCrashReportsToolkit *crashReportsToolkit;
@property (nonatomic, strong) NSMutableArray <DBCustomAction *> *customActions;
@property (nonatomic, strong) NSMutableDictionary <NSString *, DBCustomVariable *> *customVariables;
@property (nonatomic, strong) DBTopLevelViewsWrapper *topLevelViewsWrapper;

@end

@implementation DBDebugToolkit

#pragma mark - Setup

+ (void)setup {
    NSArray <id <DBDebugToolkitTrigger>> *defaultTriggers = [self defaultTriggers];
    [self setupWithTriggers:defaultTriggers];
}

+ (void)setupWithTriggers:(NSArray<id<DBDebugToolkitTrigger>> *)triggers {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    toolkit.triggers = triggers;
}

+ (NSArray <id <DBDebugToolkitTrigger>> *)defaultTriggers {
    return [NSArray arrayWithObject:[DBShakeTrigger trigger]];
}

+ (instancetype)sharedInstance {
    static DBDebugToolkit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBDebugToolkit alloc] init];
        [sharedInstance registerForNotifications];
        [sharedInstance setupTopLevelViewsWrapper];
        [sharedInstance setupPerformanceToolkit];
        [sharedInstance setupConsoleOutputCaptor];
        [sharedInstance setupNetworkToolkit];
        [sharedInstance setupUserInterfaceToolkit];
        [sharedInstance setupLocationToolkit];
        [sharedInstance setupCoreDataToolkit];
        [sharedInstance setupCustomActions];
        [sharedInstance setupCustomVariables];
        [sharedInstance setupCrashReportsToolkit];
    });
    return sharedInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setting triggers

- (void)setTriggers:(NSArray<id<DBDebugToolkitTrigger>> *)triggers {
    _triggers = [triggers copy];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self addTriggersToWindow:keyWindow];
    for (id <DBDebugToolkitTrigger> trigger in triggers) {
        trigger.delegate = self;
    }
}

- (void)addTriggersToWindow:(UIWindow *)window {
    for (id <DBDebugToolkitTrigger> trigger in self.triggers) {
        [trigger addToWindow:window];
    }
}

- (void)removeTriggersFromWindow:(UIWindow *)window {
    for (id <DBDebugToolkitTrigger> trigger in self.triggers) {
        [trigger removeFromWindow:window];
    }
}

#pragma mark - Window notifications

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newKeyWindowNotification:)
                                                 name:UIWindowDidBecomeKeyNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidResignKeyNotification:)
                                                 name:UIWindowDidResignKeyNotification
                                               object:nil];
}

- (void)newKeyWindowNotification:(NSNotification *)notification {
    UIWindow *newKeyWindow = notification.object;
    [self addTriggersToWindow:newKeyWindow];
    [self addTopLevelViewsWrapperToWindow:newKeyWindow];
}

- (void)windowDidResignKeyNotification:(NSNotification *)notification {
    UIWindow *windowResigningKey = notification.object;
    [self removeTriggersFromWindow:windowResigningKey];
}

#pragma mark - Performance toolkit

- (void)setupPerformanceToolkit {
    self.performanceToolkit = [[DBPerformanceToolkit alloc] initWithWidgetDelegate:self];
    [self.topLevelViewsWrapper addTopLevelView:self.performanceToolkit.widget];
}

#pragma mark - Console output captor

- (void)setupConsoleOutputCaptor {
    self.consoleOutputCaptor = [DBConsoleOutputCaptor sharedInstance];
    self.consoleOutputCaptor.enabled = YES;
}

+ (void)setCapturingConsoleOutputEnabled:(BOOL)enabled {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    toolkit.consoleOutputCaptor.enabled = enabled;
}

#pragma mark - Network toolkit

- (void)setupNetworkToolkit {
    self.networkToolkit = [DBNetworkToolkit sharedInstance];
    self.networkToolkit.loggingEnabled = YES;
}

+ (void)setNetworkRequestsLoggingEnabled:(BOOL)enabled {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    toolkit.networkToolkit.loggingEnabled = enabled;
}

#pragma mark - User interface toolkit

- (void)setupUserInterfaceToolkit {
    self.userInterfaceToolkit = [DBUserInterfaceToolkit sharedInstance];
    self.userInterfaceToolkit.colorizedViewBordersEnabled = NO;
    self.userInterfaceToolkit.slowAnimationsEnabled = NO;
    self.userInterfaceToolkit.showingTouchesEnabled = NO;
    [self.userInterfaceToolkit setupDebuggingInformationOverlay];
    [self.userInterfaceToolkit setupGridOverlay];
    [self.topLevelViewsWrapper addTopLevelView:self.userInterfaceToolkit.gridOverlay];
}

#pragma mark - Location toolkit

- (void)setupLocationToolkit {
    self.locationToolkit = [DBLocationToolkit sharedInstance];
}

#pragma mark - Core Data toolkit

- (void)setupCoreDataToolkit {
    self.coreDataToolkit = [DBCoreDataToolkit sharedInstance];
}

#pragma mark - Custom actions

- (void)setupCustomActions {
    self.customActions = [NSMutableArray array];
}

+ (void)addCustomAction:(DBCustomAction *)customAction {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    [toolkit.customActions addObject:customAction];
}

+ (void)addCustomActions:(NSArray <DBCustomAction *> *)customActions {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    [toolkit.customActions addObjectsFromArray:customActions];
}

+ (void)removeCustomAction:(DBCustomAction *)customAction {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    [toolkit.customActions removeObject:customAction];
}

+ (void)removeCustomActions:(NSArray <DBCustomAction *> *)customActions {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    [toolkit.customActions removeObjectsInArray:customActions];
}

#pragma mark - Custom variables

- (void)setupCustomVariables {
    self.customVariables = [NSMutableDictionary dictionary];
}

+ (void)addCustomVariable:(DBCustomVariable *)customVariable {
    [self removeCustomVariableWithName:customVariable.name];
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    toolkit.customVariables[customVariable.name] = customVariable;
}

+ (void)addCustomVariables:(NSArray <DBCustomVariable *> *)customVariables {
    for (DBCustomVariable *customVariable in customVariables) {
        [self addCustomVariable:customVariable];
    }
}

+ (void)removeCustomVariableWithName:(NSString *)variableName {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    DBCustomVariable *customVariable = toolkit.customVariables[variableName];
    [customVariable removeTarget:nil action:nil];
    toolkit.customVariables[variableName] = nil;
}

+ (void)removeCustomVariablesWithNames:(NSArray <NSString *> *)variableNames {
    for (NSString *variableName in variableNames) {
        [self removeCustomVariableWithName:variableName];
    }
}

+ (DBCustomVariable *)customVariableWithName:(NSString *)variableName {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    return toolkit.customVariables[variableName];
}

#pragma mark - Crash reports toolkit

- (void)setupCrashReportsToolkit {
    self.crashReportsToolkit = [DBCrashReportsToolkit sharedInstance];
    self.crashReportsToolkit.consoleOutputCaptor = self.consoleOutputCaptor;
    self.crashReportsToolkit.buildInfoProvider = [DBBuildInfoProvider new];
    self.crashReportsToolkit.deviceInfoProvider = [DBDeviceInfoProvider new];
}

+ (void)setupCrashReporting {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    [toolkit.crashReportsToolkit setupCrashReporting];
}

#pragma mark - Resources 

+ (void)clearKeychain {
    DBKeychainToolkit *keychainToolkit = [DBKeychainToolkit new];
    [keychainToolkit handleClearAction];
}

+ (void)clearUserDefaults {
    DBUserDefaultsToolkit *userDefaultsToolkit = [DBUserDefaultsToolkit new];
    [userDefaultsToolkit handleClearAction];
}

+ (void)clearDocuments {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray <NSString *> *documentsContents = [fileManager contentsOfDirectoryAtPath:documentsPath error:nil];
    for (NSString *file in documentsContents) {
        NSString *filePath = [documentsPath stringByAppendingPathComponent:file];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

+ (void)clearCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        [cookieStorage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Shortcut items

+ (void)addClearDataShortcutItem {
    if (![[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9, 0, 0}]) {
        // Shortcut items are not supported on the running iOS version.
        return;
    }

    NSArray <UIApplicationShortcutItem *> *shortcutItems = UIApplication.sharedApplication.shortcutItems;
    for (UIApplicationShortcutItem *item in shortcutItems) {
        if ([item.type isEqualToString:DBClearDataShortcutItemType]) {
            // We already added `Clear data` shortcut item.
            return;
        }
    }

    UIApplicationShortcutIcon *shortcutIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    UIApplicationShortcutItem *clearDataShortcutItem = [[UIApplicationShortcutItem alloc] initWithType:DBClearDataShortcutItemType
                                                                                        localizedTitle:@"Clear data"
                                                                                     localizedSubtitle:@"DBDebugToolkit"
                                                                                                  icon:shortcutIcon
                                                                                              userInfo:nil];
    NSMutableArray *newShortcutItems = shortcutItems == nil ? [NSMutableArray array] : [NSMutableArray arrayWithArray:shortcutItems];
    [newShortcutItems insertObject:clearDataShortcutItem atIndex:0];
    UIApplication.sharedApplication.shortcutItems = [newShortcutItems copy];
}

+ (void)handleClearDataShortcutItemAction {
    [self clearUserDefaults];
    [self clearKeychain];
    [self clearDocuments];
    [self clearCookies];
}

#pragma mark - Top level views

- (void)setupTopLevelViewsWrapper {
    self.topLevelViewsWrapper = [DBTopLevelViewsWrapper new];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [self addTopLevelViewsWrapperToWindow:keyWindow];
}

- (void)addTopLevelViewsWrapperToWindow:(UIWindow *)window {
    [self.topLevelViewsWrapper.superview removeObserver:self forKeyPath:@"layer.sublayers"];
    [window addSubview:self.topLevelViewsWrapper];
    // We observe the "layer.sublayers" property of the window to keep the widget on top.
    [window addObserver:self
             forKeyPath:@"layer.sublayers"
                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                context:nil];
}

#pragma mark - Convenience methods

+ (void)showMenu {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    if (!toolkit.showsMenu) {
        [toolkit showMenu];
    }
}

+ (void)showPerformanceWidget {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    DBPerformanceToolkit *performanceToolkit = toolkit.performanceToolkit;
    performanceToolkit.isWidgetShown = YES;
}

+ (void)showDebuggingInformationOverlay {
    DBDebugToolkit *toolkit = [DBDebugToolkit sharedInstance];
    DBUserInterfaceToolkit *userInterfaceToolkit = toolkit.userInterfaceToolkit;
    if (userInterfaceToolkit.isDebuggingInformationOverlayAvailable) {
        [userInterfaceToolkit showDebuggingInformationOverlay];
    }
}

#pragma mark - Showing menu

- (void)showMenu {
    self.showsMenu = YES;
    UIViewController *presentingViewController = [self topmostViewController];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.menuViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    navigationController.modalPresentationCapturesStatusBarAppearance = YES;
    [presentingViewController presentViewController:navigationController animated:YES completion:^{
        // We need this to properly handle a case of menu being dismissed because of dismissing of the view controller that presents it.
        [navigationController.presentationController addObserver:self
                                                      forKeyPath:DBDebugToolkitObserverPresentationControllerPropertyKeyPath
                                                         options:0
                                                         context:nil];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[UIPresentationController class]]) {
        UIPresentationController *presentationController = (UIPresentationController *)object;
        if (presentationController.containerView == nil) {
            // The menu was dismissed.
            self.showsMenu = NO;
            [presentationController removeObserver:self forKeyPath:DBDebugToolkitObserverPresentationControllerPropertyKeyPath];
        }
    } else if ([object isKindOfClass:[UIWindow class]]) {
        [self.topLevelViewsWrapper.superview bringSubviewToFront:self.topLevelViewsWrapper];
    }
}

- (DBMenuTableViewController *)menuViewController {
    if (!_menuViewController) {
        NSBundle *bundle = [NSBundle debugToolkitBundle];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBMenuTableViewController" bundle:bundle];
        _menuViewController = [storyboard instantiateInitialViewController];
        _menuViewController.performanceToolkit = self.performanceToolkit;
        _menuViewController.consoleOutputCaptor = self.consoleOutputCaptor;
        _menuViewController.networkToolkit = self.networkToolkit;
        _menuViewController.userInterfaceToolkit = self.userInterfaceToolkit;
        _menuViewController.locationToolkit = self.locationToolkit;
        _menuViewController.coreDataToolkit = self.coreDataToolkit;
        _menuViewController.crashReportsToolkit = self.crashReportsToolkit;
        _menuViewController.buildInfoProvider = [DBBuildInfoProvider new];
        _menuViewController.deviceInfoProvider = [DBDeviceInfoProvider new];
        _menuViewController.delegate = self;
    }
    _menuViewController.customVariables = self.customVariables.allValues;
    _menuViewController.customActions = self.customActions;
    return _menuViewController;
}

- (UIViewController *)topmostViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self topmostViewControllerWithRootViewController:rootViewController];
}

- (UIViewController *)topmostViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topmostViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        if (navigationController.visibleViewController == nil) {
            return navigationController;
        }
        return [self topmostViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topmostViewControllerWithRootViewController:presentedViewController];
    }
    return rootViewController;
}

#pragma mark - DBDebugToolkitTriggerDelegate

- (void)debugToolkitTriggered:(id<DBDebugToolkitTrigger>)trigger {
    if (!self.showsMenu) {
        [self showMenu];
    }
}

#pragma mark - DBMenuTableViewControllerDelegate

- (void)menuTableViewControllerDidTapClose:(DBMenuTableViewController *)menuTableViewController {
    UIViewController *presentingViewController = self.menuViewController.navigationController.presentingViewController;
    [presentingViewController dismissViewControllerAnimated:YES completion:^{
        self.showsMenu = NO;
    }];
}

#pragma mark - DBPerformanceWidgetViewDelegate 

- (void)performanceWidgetView:(DBPerformanceWidgetView *)performanceWidgetView didTapOnSection:(DBPerformanceSection)section {
    BOOL shouldAnimateShowingPerformance = YES;
    if (!self.showsMenu) {
        [self showMenu];
        shouldAnimateShowingPerformance = NO;
    }
    UINavigationController *navigationController = self.menuViewController.navigationController;
    if (navigationController.viewControllers.count > 1 && [navigationController.viewControllers[1] isKindOfClass:[DBPerformanceTableViewController class]]) {
        // Only update the presented DBPerformanceTableViewController instance.
        DBPerformanceTableViewController *performanceTableViewController = (DBPerformanceTableViewController *)navigationController.viewControllers[1];
        performanceTableViewController.selectedSection = section;
    } else {
        // Update navigation controller's view controllers.
        [self.menuViewController openPerformanceMenuWithSection:section
                                                       animated:shouldAnimateShowingPerformance];
    }
}

@end
