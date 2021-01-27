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
#import <UIKit/UIKit.h>
#import "DBBuildInfoProvider.h"

extern NSString *const DBUserInterfaceToolkitColorizedViewBordersChangedNotification;


@protocol DBDebugSettingsDelegate <NSObject>

@optional
- (void)dbDebugSettingsWidgetChange:(BOOL) flag;
- (void)dbDebugSettingsCrashLoggingChange:(BOOL) flag;
- (void)dbDebugSettingsNetworkLoggingChange:(BOOL) flag;
- (void)dbDebugSettingsConsoleLoggingChange:(BOOL) flag;
- (void)dbDebugSettingsPerformanceCaptureChange:(BOOL) flag;
//Triggers
- (void)dbDebugSettingsLongpressTriggerChange:(BOOL) flag;
- (void)dbDebugSettingsShakeTriggerChange:(BOOL) flag;
- (void)dbDebugSettingsTapTriggerChange:(BOOL) flag;
@end

@interface DBDebugSettings : NSObject



@property (nonatomic, weak) id<DBDebugSettingsDelegate> delegate;


/**
 Returns the singleton instance.
 */
+ (instancetype)sharedInstance;

/**
 Settings fields.
 */
@property (nonatomic, assign) BOOL widgetEnabled;

@property (nonatomic, assign) BOOL crashLoggingEnabled;

@property (nonatomic, assign) BOOL networkLoggingEnabled;

@property (nonatomic, assign) BOOL consoleLoggingEnabled;

@property (nonatomic, assign) BOOL performanceCaptureEnabled;

//Triggers
@property (nonatomic, assign) BOOL longpressTriggerEnabled;

@property (nonatomic, assign) BOOL shakeTriggerEnabled;

@property (nonatomic, assign) BOOL tapTriggerEnabled;
//Presets
@property (nonatomic, retain) NSString* selectedPresets;

/**
 Settings fields methods.
 */
- (void)updateWidgetEnabled:(BOOL)flag;

- (void)updateCrashLoggingEnabled:(BOOL)flag;

- (void)updateNetworkLoggingEnabled:(BOOL)flag;

- (void)updateConsoleLoggingEnabled:(BOOL)flag;

- (void)updatePerformanceCaptureEnabled:(BOOL)flag;
//Triggers
- (void)updateLongpressTriggerEnabled:(BOOL)flag;
- (void)updateShakeTriggerEnabled:(BOOL)flag;
- (void)updateTapTriggerEnabled:(BOOL)flag;
//Presets
- (void)updateSelectedPresets:(NSString*)value;
/**
 File write/read methods.
 */

-(void)defaultSetting;

-(void)updateSettingsFile;


@property (nonatomic, strong)DBBuildInfoProvider *buildInfoProvider;

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
 Returns the autolayout trace for the key window.
 */
- (void)autolayoutTrace;

/**
 Returns the description of the current screen (below the `DBMenuTableViewController`).
 */
- (void)viewDescription:(UIView *)view;

/**
 Returns the hierarchy of view controllers in key window.
 */
- (void)viewControllerHierarchy;

///------------------------------------
/// @name UIDebuggingInformationOverlay
///------------------------------------

/**
 Toggles visibility of the `UIDebuggingInformationOverlay`.
 */
- (void)writeStringToFile:(NSString*)aString;
/**
 Sets up the `UIDebuggingInformationOverlay`.
 */
- (void)readStringFromFile;
@end



