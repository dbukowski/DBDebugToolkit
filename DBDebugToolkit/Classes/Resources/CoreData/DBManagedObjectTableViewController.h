//
//  DBManagedObjectTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DBManagedObjectTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObject *managedObject;

@end
