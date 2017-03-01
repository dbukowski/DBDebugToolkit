//
//  DBManagedObjectsListTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 28.02.2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DBManagedObjectsListTableViewController : UITableViewController

@property (nonatomic, strong) NSString *entityName;

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSArray <NSManagedObject *> *managedObjects;

@end
