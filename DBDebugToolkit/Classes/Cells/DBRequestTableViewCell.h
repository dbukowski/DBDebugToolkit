//
//  DBRequestTableViewCell.h
//  Pods
//
//  Created by Dariusz Bukowski on 24.01.2017.
//
//

#import <UIKit/UIKit.h>
#import "DBRequestModel.h"

@interface DBRequestTableViewCell : UITableViewCell

- (void)configureWithRequestModel:(DBRequestModel *)requestModel;

@end
