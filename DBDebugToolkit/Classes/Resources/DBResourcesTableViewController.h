//
//  DBResourcesTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 09.02.2017.
//
//

#import <UIKit/UIKit.h>
#import "DBCoreDataToolkit.h"

@interface DBResourcesTableViewController : UITableViewController

@property (nonatomic, strong) DBCoreDataToolkit *coreDataToolkit;

@end
