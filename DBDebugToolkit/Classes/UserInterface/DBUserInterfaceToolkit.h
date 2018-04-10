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

#import <Foundation/Foundation.h>
#import "DBGridOverlayView.h"
#import "DBGridOverlayColorScheme.h"

/**
 String containing the name of notifications send to inform about change in colorized view borders settings.
 */
extern NSString *const DBUserInterfaceToolkitColorizedViewBordersChangedNotification;

/**
 `DBUserInterfaceToolkit` is a class responsible for managing the user interface debugging settings and generating a debug description strings.
 */
@interface DBUserInterfaceToolkit : NSObject

/**
 Returns the singleton instance.
 */
+ (instancetype)sharedInstance;

/**
 Boolean flag determining whether colorized view borders are enabled or not.
 */
@property (nonatomic, assign) BOOL colorizedViewBordersEnabled;

/**
 Boolean flag determining whether slow animations are enabled or not.
 */
@property (nonatomic, assign) BOOL slowAnimationsEnabled;

/**
 Boolean flag determining whether showing touches is enabled or not.
 */
@property (nonatomic, assign) BOOL showingTouchesEnabled;

/**
 Boolean determining whether the grid overlay should be shown or not.
 */
@property (nonatomic, assign) BOOL isGridOverlayShown;

/**
 Created grid overlay displayed on top of the screen.
 */
@property (nonatomic, readonly) DBGridOverlayView *gridOverlay;

/**
 An array of available grid overlay color schemes. Read-only.
 */
@property (nonatomic, readonly) NSArray <DBGridOverlayColorScheme *> *gridOverlayColorSchemes;

/**
 The index of the currently selected color scheme.
 */
@property (nonatomic, assign) NSInteger selectedGridOverlayColorSchemeIndex;

/**
 Sets up the `DBGridOverlayView`.
 */
- (void)setupGridOverlay;

/**
 Returns the autolayout trace for the key window.
 */
- (NSString *)autolayoutTrace;

/**
 Returns the description of the current screen (below the `DBMenuTableViewController`).
 */
- (NSString *)viewDescription:(UIView *)view;

/**
 Returns the hierarchy of view controllers in key window.
 */
- (NSString *)viewControllerHierarchy;

///------------------------------------
/// @name UIDebuggingInformationOverlay
///------------------------------------

/**
 Returns `true` if the `UIDebuggingInformationOverlay` class is available.
 */
- (BOOL)isDebuggingInformationOverlayAvailable;

/**
 Toggles visibility of the `UIDebuggingInformationOverlay`.
 */
- (void)showDebuggingInformationOverlay;

/**
 Sets up the `UIDebuggingInformationOverlay`.
 */
- (void)setupDebuggingInformationOverlay;

@end
