//
//  DBExampleCollectionViewCell.m
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 11.03.2017.
//  Copyright © 2017 Dariusz Bukowski. All rights reserved.
//

#import "DBExampleCollectionViewCell.h"

@interface DBExampleCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIView *backgroundColorView;

@end

@implementation DBExampleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColorView.layer.cornerRadius = 4.0;
    self.backgroundColorView.layer.masksToBounds = YES;
}

- (void)configureWithColor:(UIColor *)color title:(NSString *)title {
    self.backgroundColorView.backgroundColor = color;
    self.titleLabel.text = title;
}

@end
