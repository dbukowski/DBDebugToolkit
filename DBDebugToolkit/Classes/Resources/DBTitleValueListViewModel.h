//
//  DBTitleValueListViewModel.h
//  Pods
//
//  Created by Dariusz Bukowski on 12.02.2017.
//
//

#import <Foundation/Foundation.h>
#import "DBTitleValueTableViewCellDataSource.h"

@protocol DBTitleValueListViewModel

- (NSInteger)numberOfItems;

- (NSString *)viewTitle;

- (DBTitleValueTableViewCellDataSource *)dataSourceForItemAtIndex:(NSInteger)index;

- (void)handleClearAction;

- (void)handleDeleteItemActionAtIndex:(NSInteger)index;

- (NSString *)emptyListDescriptionString;

@end
