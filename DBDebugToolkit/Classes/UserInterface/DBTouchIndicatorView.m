// The MIT License
//
// Copyright (c) 2016 Dariusz Bukowski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
    self.layer.zPosition = FLT_MAX;
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
