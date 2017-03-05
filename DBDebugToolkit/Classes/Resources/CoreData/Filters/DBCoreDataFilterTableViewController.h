//
//  DBCoreDataFilterTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

#import <UIKit/UIKit.h>
#import "DBCoreDataFilter.h"

@class DBCoreDataFilterTableViewController;

@protocol DBCoreDataFilterTableViewControllerDelegate <NSObject>

- (void)filterTableViewControllerDidTapClose:(DBCoreDataFilterTableViewController *)filterTableViewController;
- (void)filterTableViewController:(DBCoreDataFilterTableViewController *)filterTableViewController didTapSaveWithFilter:(DBCoreDataFilter *)filter;

@end

@interface DBCoreDataFilterTableViewController : UITableViewController

@property (nonatomic, strong) DBCoreDataFilter *filter;

@property (nonatomic, strong) NSArray <NSAttributeDescription *> *attributes;

@property (nonatomic, weak) id <DBCoreDataFilterTableViewControllerDelegate> delegate;

@end
