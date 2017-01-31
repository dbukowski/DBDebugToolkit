//
//  DBTitleValueTableViewCell.m
//  Pods
//
//  Created by Dariusz Bukowski on 31.01.2017.
//
//

#import "DBTitleValueTableViewCell.h"

@interface DBTitleValueTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation DBTitleValueTableViewCell

- (void)configureWithDataSource:(DBTitleValueTableViewCellDataSource *)dataSource {
    self.titleLabel.text = dataSource.title;
    self.valueLabel.text = dataSource.value;
}

@end
