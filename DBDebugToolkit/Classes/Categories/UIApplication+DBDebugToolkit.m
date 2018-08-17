// The MIT License
//
// Copyright (c) 2017 Dariusz Bukowski
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

#import "UIApplication+DBDebugToolkit.h"
#import "NSObject+DBDebugToolkit.h"
#import "DBDebugToolkit.h"
#import <objc/runtime.h>

NSString *const DBClearDataShortcutItemType = @"DBClearDataShortcutItemType";

@implementation UIApplication (DBDebugToolkit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __block IMP originalIMP = [self replaceMethodWithSelector:@selector(setDelegate:)
                                                            block:^(UIApplication *blockSelf, id <UIApplicationDelegate>delegate) {
                                                                Class delegateClass = [delegate class];
                                                                [self addClearDataShortcutHandlingForClass:delegateClass];
                                                                ((void (*)(id, SEL, id <UIApplicationDelegate>))originalIMP)(blockSelf, @selector(setDelegate:), delegate);
                                                            }];
    });
}

+ (void)addClearDataShortcutHandlingForClass:(Class)class {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9, 0, 0}]) {
            // Shortcut items are not supported on the running iOS version.
            return;
        }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpartial-availability"
        SEL selector = @selector(application:performActionForShortcutItem:completionHandler:);
        Method originalMethod = class_getInstanceMethod(class, selector);
        if (originalMethod) {
            __block IMP originalIMP = [class replaceMethodWithSelector:selector
                                                                 block:^(id <UIApplicationDelegate> blockSelf,
                                                                         UIApplication *application,
                                                                         UIApplicationShortcutItem *shortcutItem,
                                                                         void (^completionHandler)(BOOL succeeded)) {
                                                                     if ([shortcutItem.type isEqualToString:DBClearDataShortcutItemType]) {
                                                                         [DBDebugToolkit handleClearDataShortcutItemAction];
                                                                     }
                                                                     ((void (*)(id, SEL, UIApplication *, UIApplicationShortcutItem *, void (^)(BOOL succeeded)))originalIMP)(blockSelf, @selector(application:performActionForShortcutItem:completionHandler:), application, shortcutItem, completionHandler);
                                                                 }];
        } else {
            void (^block)(id <UIApplicationDelegate> blockSelf,
                          UIApplication *application,
                          UIApplicationShortcutItem *shortcutItem,
                          void (^completionHandler)(BOOL succeeded)) = ^(id <UIApplicationDelegate> blockSelf,
                                                                         UIApplication *application,
                                                                         UIApplicationShortcutItem *shortcutItem,
                                                                         void (^completionHandler)(BOOL succeeded)) {
                if ([shortcutItem.type isEqualToString:DBClearDataShortcutItemType]) {
                    [DBDebugToolkit handleClearDataShortcutItemAction];
                }
            };

            IMP implementation = imp_implementationWithBlock(block);
            class_addMethod(class, selector, implementation, "v@:@@@");
        }
#pragma clang diagnostic pop
    });
}

@end
