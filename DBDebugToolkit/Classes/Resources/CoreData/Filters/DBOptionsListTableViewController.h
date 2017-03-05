//
//  DBOptionsListTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

#import <UIKit/UIKit.h>

@class DBOptionsListTableViewController;

@protocol DBOptionsListTableViewControllerDelegate <NSObject>

- (void)optionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController didSelectOptionAtIndex:(NSInteger)optionIndex;

@end

@protocol DBOptionsListTableViewControllerDataSource <NSObject>

- (NSInteger)numberOfOptionsInOptionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController;
- (NSInteger)selectedIndexInOptionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController;
- (NSString *)optionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController titleAtIndex:(NSInteger)index;

@end

@interface DBOptionsListTableViewController : UITableViewController

@property (nonatomic, weak) id <DBOptionsListTableViewControllerDataSource> dataSource;

@property (nonatomic, weak) id <DBOptionsListTableViewControllerDelegate> delegate;

@end
