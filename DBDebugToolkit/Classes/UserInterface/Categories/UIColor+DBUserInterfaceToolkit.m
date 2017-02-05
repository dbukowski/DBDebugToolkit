//
//  UIColor+DBUserInterfaceToolkit.m
//  Pods
//
//  Created by Dariusz Bukowski on 05.02.2017.
//
//

#import "UIColor+DBUserInterfaceToolkit.h"

@implementation UIColor (DBUserInterfaceToolkit)

+ (instancetype)randomColor {
    CGFloat red = (arc4random() % 256) / 255.0;
    CGFloat green = (arc4random() % 256) / 255.0;
    CGFloat blue = (arc4random() % 256) / 255.0;
    return [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
}

@end
