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
#import "DBCoreDataToolkit.h"

@class DBPersistentStoreCoordinatorsTableViewController;

/**
 A protocol used for informing about the selection of one of the displayed persistent store coordinators.
 */
@protocol DBPersistentStoreCoordinatorsTableViewControllerDelegate <NSObject>

/**
 Informs the delegate about selecting the persistent store coordinator.
 
 @param persistentStoreCoordinatorsTableViewController The `DBPersistentStoreCoordinatorsTableViewController` instance that recorded the selection.
 @param persistentStoreCoordinator The selected `NSPersistentStoreCoordinator` instance.
 */
- (void)persistentStoreCoordinatorsTableViewController:(DBPersistentStoreCoordinatorsTableViewController *)persistentStoreCoordinatorsTableViewController
                   didSelectPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end

/**
 `DBPersistentStoreCoordinatorsTableViewController` is a table view controller presenting the list of persistent store coordinators stored in the `DBCoreDataToolkit` instance.
 */
@interface DBPersistentStoreCoordinatorsTableViewController : UITableViewController

/**
 The `DBCoreDataToolkit` instance that will provide the data for the table view controller.
 */
@property (nonatomic, strong) DBCoreDataToolkit *coreDataToolkit;

/**
 The delegate that will be informed about selecting one of the persistent store coordinators.It needs to conform to `DBPersistentStoreCoordinatorsTableViewControllerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBPersistentStoreCoordinatorsTableViewControllerDelegate> delegate;

@end
