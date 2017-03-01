//
//  DBEntitiesTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 28.02.2017.
//
//

#import <UIKit/UIKit.h>

@interface DBEntitiesTableViewController : UITableViewController

@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
