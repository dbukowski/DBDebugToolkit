//
//  DBTouchIndicatorView.m
//  Pods
//
//  Created by Dariusz Bukowski on 05.02.2017.
//
//

static const CGSize DBTouchIndicatorViewDefaultSize = { 40.0, 40.0 };

#import "DBTouchIndicatorView.h"

@implementation DBTouchIndicatorView

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    
    return self;
}

+ (instancetype)indicatorView {
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DBTouchIndicatorViewDefaultSize.width, DBTouchIndicatorViewDefaultSize.height)];
}

- (void)setupView {
    self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.7];
    self.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.7].CGColor;
    self.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    [self.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [self.layer setShadowOpacity:0.7];
    [self.layer setShadowRadius:3.0];
    [self.layer setShadowOffset:CGSizeMake(4.0, 4.0)];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = MIN(self.frame.size.width, self.frame.size.height) / 2;
}

@end
