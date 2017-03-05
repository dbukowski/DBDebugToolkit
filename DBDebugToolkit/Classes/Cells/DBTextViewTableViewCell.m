//
//  DBTextViewTableViewCell.m
//  Pods
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//

#import "DBTextViewTableViewCell.h"

@implementation DBTextViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.textContainer.lineFragmentPadding = 0;
    self.textView.textContainerInset = UIEdgeInsetsZero;
}

@end
