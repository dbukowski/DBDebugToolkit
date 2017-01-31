//
//  DBTitleValueTableViewCell.h
//  Pods
//
//  Created by Dariusz Bukowski on 31.01.2017.
//
//

#import <UIKit/UIKit.h>
#import "DBTitleValueTableViewCellDataSource.h"

@interface DBTitleValueTableViewCell : UITableViewCell

- (void)configureWithDataSource:(DBTitleValueTableViewCellDataSource *)dataSource;

@end
