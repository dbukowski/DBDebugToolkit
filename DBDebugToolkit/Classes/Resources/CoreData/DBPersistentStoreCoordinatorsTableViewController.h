//
//  DBPersistentStoreCoordinatorsTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 28.02.2017.
//
//

#import <UIKit/UIKit.h>
#import "DBCoreDataToolkit.h"

@class DBPersistentStoreCoordinatorsTableViewController;

@protocol DBPersistentStoreCoordinatorsTableViewControllerDelegate <NSObject>

- (void)persistentStoreCoordinatorsTableViewController:(DBPersistentStoreCoordinatorsTableViewController *)persistentStoreCoordinatorsTableViewController
                   didSelectPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end

@interface DBPersistentStoreCoordinatorsTableViewController : UITableViewController

@property (nonatomic, strong) DBCoreDataToolkit *coreDataToolkit;

@property (nonatomic, weak) id <DBPersistentStoreCoordinatorsTableViewControllerDelegate> delegate;

@end
