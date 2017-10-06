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

#import <UIKit/UIKit.h>
#import "DBPerformanceToolkit.h"
#import "DBConsoleOutputCaptor.h"
#import "DBBuildInfoProvider.h"
#import "DBDeviceInfoProvider.h"
#import "DBNetworkToolkit.h"
#import "DBUserInterfaceToolkit.h"
#import "DBLocationToolkit.h"
#import "DBCoreDataToolkit.h"
#import "DBCustomAction.h"
#import "DBCustomVariable.h"
#import "DBCrashReportsToolkit.h"

@class DBMenuTableViewController;

/**
 A protocol used to communicate between `DBMenuTableViewController` object and the object that presented it.
 */
@protocol DBMenuTableViewControllerDelegate <NSObject>

/**
 Informs the delegate that the user tapped `Close` button in the `DBMenuTableViewController`.
 
 @param menuTableViewController `DBMenuTableViewController` object that should be dismissed.
 */
- (void)menuTableViewControllerDidTapClose:(DBMenuTableViewController *)menuTableViewController;

@end

/**
 `DBMenuTableViewController` is the main view controller used by `DBDebugToolkit`. It contains a `UITableView` containing all the debug tools.
 */
@interface DBMenuTableViewController : UITableViewController

/**
 The delegate adopting `DBMenuTableViewControllerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBMenuTableViewControllerDelegate> delegate;

/**
 `DBPerformanceToolkit` instance that will be passed on.
 */
@property (nonatomic, strong) DBPerformanceToolkit *performanceToolkit;

/**
 `DBConsoleOutputCaptor` instance that will be passed on.
 */
@property (nonatomic, strong) DBConsoleOutputCaptor *consoleOutputCaptor;

/**
 `DBNetworkToolkit` instance that will be passed on.
 */
@property (nonatomic, strong) DBNetworkToolkit *networkToolkit;

/**
 `DBUserInterfaceToolkit` instance that will be passed on.
 */
@property (nonatomic, strong) DBUserInterfaceToolkit *userInterfaceToolkit;

/**
 `DBLocationToolkit` instance that will be passed on.
 */
@property (nonatomic, strong) DBLocationToolkit *locationToolkit;

/**
 `DBCoreDataToolkit` instance that will be passed on.
 */
@property (nonatomic, strong) DBCoreDataToolkit *coreDataToolkit;

/**
 `DBBuildInfoProvider` instance that will provide data for section header.
 */
@property (nonatomic, strong) DBBuildInfoProvider *buildInfoProvider;

/**
 `DBDeviceInfoProvider` instance that will provide data for section footer.
 */
@property (nonatomic, strong) DBDeviceInfoProvider *deviceInfoProvider;

/**
 `DBCrashReportsToolkit` instance that will be passed on.
 */
@property (nonatomic, strong) DBCrashReportsToolkit *crashReportsToolkit;

/**
 Array of `DBCustomAction` instances that will be passed on.
 */
@property (nonatomic, copy) NSArray <DBCustomAction *> *customActions;

/**
 Array of `DBCustomVariable` instances that will be passed on.
 */
@property (nonatomic, copy) NSArray <DBCustomVariable *> *customVariables;

/**
 Pushes `DBPerformanceTableViewController` onto the current navigation controller with the preselected section. Optionally animated.
 
 @param section Preselected section in performance table view controller.
 @param animated Boolean determining whether the push should be animated or not.
 */
- (void)openPerformanceMenuWithSection:(DBPerformanceSection)section animated:(BOOL)animated;

@end
