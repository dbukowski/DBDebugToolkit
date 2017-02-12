//
//  DBTitleValueListTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 12.02.2017.
//
//

#import <UIKit/UIKit.h>
#import "DBTitleValueListViewModel.h"

@interface DBTitleValueListTableViewController : UITableViewController

@property (nonatomic, strong) id <DBTitleValueListViewModel> viewModel;

@end
