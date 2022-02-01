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
#import "DBDebugToolkitTrigger.h"
#import "DBLongPressTrigger.h"
#import "DBShakeTrigger.h"
#import "DBTapTrigger.h"
#import "DBCustomAction.h"
#import "DBCustomVariable.h"

/**
 `DBDebugToolkit` provides the interface that can be used to setup and customize the debugging tools.
 */
@interface DBDebugToolkit : NSObject

///------------
/// @name Setup
///------------

/**
 Sets up the `DBDebugToolkit` with one default trigger: `DBShakeTrigger`.
*/
+ (void)setup;

/**
 Sets up the `DBDebugToolkit` with provided triggers.
 
 @param triggers Array of triggers that should be used to open the `DBDebugToolkit` menu. The objects it contains should adopt the protocol `DBDebugToolkitTrigger`.
 */
+ (void)setupWithTriggers:(NSArray <id <DBDebugToolkitTrigger>> *)triggers;


///--------------------------
/// @name Convenience methods
///--------------------------

/**
 Enables or disables console output capturing, which by default is enabled.
 
 @param enabled Determines whether console output capturing should be enabled or disabled.
 */
+ (void)setCapturingConsoleOutputEnabled:(BOOL)enabled;

/**
 Enables or disables network requests logging, which by default is enabled.
 
 @param enabled Determines whether network requests logging should be enabled or disabled.
 */
+ (void)setNetworkRequestsLoggingEnabled:(BOOL)enabled;

/**
 Removes all your application's entries from the keychain.
 */
+ (void)clearKeychain;

/**
 Removes all your application's entries from the `NSUserDefaults`.
 */
+ (void)clearUserDefaults;

/**
 Removes all files from the documents directory.
 */
+ (void)clearDocuments;

/**
 Removes all cookies.
 */
+ (void)clearCookies;

/**
 Returns the menu view controller.
 */
+ (UIViewController*)menuViewController;

/**
 Shows the menu.
 */
+ (void)showMenu;

/**
 Closes the menu.
 */
+ (void)closeMenu;

/**
 Shows the performance widget.
 */
+ (void)showPerformanceWidget;

/**
 Shows the `UIDebuggingInformationOverlay` (if available).
 */
+ (void)showDebuggingInformationOverlay;

///---------------------
/// @name Custom actions
///---------------------

/**
 Adds a single `DBCustomAction` instance to the array accessible in the menu.
 
 @param customAction The `DBCustomAction` instance that should be accessible in the menu.
 */
+ (void)addCustomAction:(DBCustomAction *)customAction;

/**
 Adds multiple `DBCustomAction` instances to the array accessible in the menu.
 
 @param customActions An array of `DBCustomAction` instances that should be accessible in the menu.
 */
+ (void)addCustomActions:(NSArray <DBCustomAction *> *)customActions;

/**
 Removes a single `DBCustomAction` instance from the array accessible in the menu.
 
 @param customAction The `DBCustomAction` instance that should be removed.
 */
+ (void)removeCustomAction:(DBCustomAction *)customAction;

/**
 Removes multiple `DBCustomAction` instances from the array accessible in the menu.
 
 @param customActions An array of `DBCustomAction` instances that should be accessible in the menu.
 */
+ (void)removeCustomActions:(NSArray <DBCustomAction *> *)customActions;

///-----------------------
/// @name Custom variables
///-----------------------

/**
 Adds a single `DBCustomVariable` instance to the array accessible in the menu.
 
 @param customVariable The `DBCustomVariable` instance that should be accessible in the menu.
 */
+ (void)addCustomVariable:(DBCustomVariable *)customVariable;

/**
 Adds multiple `DBCustomVariable` instances to the array accessible in the menu.
 
 @param customVariables An array of `DBCustomVariable` instances that should be accessible in the menu.
 */
+ (void)addCustomVariables:(NSArray <DBCustomVariable *> *)customVariables;

/**
 Removes a single `DBCustomVariable` instance with the given name.
 
 @param variableName The name of the variable that should be removed.
 */
+ (void)removeCustomVariableWithName:(NSString *)variableName;

/**
 Removes multiple `DBCustomVariable` instances with the names contained in the given array.
 
 @param variableNames An array of the names of the variables that should be removed.
 */
+ (void)removeCustomVariablesWithNames:(NSArray <NSString *> *)variableNames;

/**
 Returns a `DBCustomVariable` instance with a given name. If there is no such an instance, the method returns `nil`.
 
 @param variableName The name of the accessed variable.
 */
+ (DBCustomVariable *)customVariableWithName:(NSString *)variableName;

///--------------------
/// @name Crash reports
///--------------------

/**
 Enables collecting crash reports.
 */
+ (void)setupCrashReporting;


///---------------------
/// @name Shortcut Items
///---------------------

/**
 Adds a `Clear data` shortcut item.
 */
+ (void)addClearDataShortcutItem NS_AVAILABLE_IOS(9_0);

/**
 Handles `Clear data` shortcut item action.
 */
+ (void)handleClearDataShortcutItemAction NS_AVAILABLE_IOS(9_0);

@end
