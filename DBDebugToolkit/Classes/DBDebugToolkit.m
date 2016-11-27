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

@interface DBDebugToolkit () <DBDebugToolkitTriggerDelegate, DBMenuTableViewControllerDelegate>

@property (nonatomic, copy) NSArray <id <DBDebugToolkitTrigger>> *triggers;
@property (nonatomic, strong) DBMenuTableViewController *menuViewController;
@property (nonatomic, assign) BOOL showsMenu;

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
}

- (void)windowDidResignKeyNotification:(NSNotification *)notification {
    UIWindow *windowResigningKey = notification.object;
    [self removeTriggersFromWindow:windowResigningKey];
}

#pragma mark - Showing menu

- (void)showMenu {
    self.showsMenu = true;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.menuViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    UIViewController *presentingViewController = [self topmostViewController];
    [presentingViewController presentViewController:navigationController animated:YES completion: nil];
}

- (DBMenuTableViewController *)menuViewController {
    if (!_menuViewController) {
        NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
        NSURL *bundleURL = [podBundle URLForResource:@"DBDebugToolkit" withExtension:@"bundle"];
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBMenuTableViewController" bundle:bundle];
        _menuViewController = [storyboard instantiateInitialViewController];
        _menuViewController.delegate = self;
    }
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
    [presentingViewController dismissViewControllerAnimated:true completion:nil];
}

@end
