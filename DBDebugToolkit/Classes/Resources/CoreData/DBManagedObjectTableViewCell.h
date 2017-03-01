//
//  DBManagedObjectTableViewCell.h
//  Pods
//
//  Created by Dariusz Bukowski on 01.03.2017.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DBManagedObjectTableViewCell : UITableViewCell

- (void)configureWithManagedObject:(NSManagedObject *)managedObject;

@end
