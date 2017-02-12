//
//  UILabel+DBDebugToolkit.m
//  Pods
//
//  Created by Dariusz Bukowski on 12.02.2017.
//
//

#import "UILabel+DBDebugToolkit.h"

@implementation UILabel (DBDebugToolkit)

+ (instancetype)tableViewBackgroundLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    return label;
}

@end
