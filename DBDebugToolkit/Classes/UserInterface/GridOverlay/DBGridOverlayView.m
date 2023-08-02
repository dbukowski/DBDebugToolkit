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

#import "DBGridOverlayView.h"

static const NSInteger DBGridOverlayViewMinHorizontalMiddlePartSize = 8;
static const NSInteger DBGridOverlayViewMinVerticalMiddlePartSize = 8;
static const CGFloat DBGridOverlayViewLabelFontSize = 9.0;
static const CGFloat DBGridOverlayViewHorizontalLabelTopOffset = 72.0;
static const CGFloat DBGridOverlayViewVerticalLabelRightOffset = 32.0;
static const CGFloat DBGridOverlayViewVerticalLabelContentOffsets = 4.0;

@interface DBGridOverlayView ()

@property (nonatomic, strong) UILabel *horizontalLabel;
@property (nonatomic, strong) UILabel *verticalLabel;

@end

@implementation DBGridOverlayView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    [self updateFrame];
    self.userInteractionEnabled = NO;
    self.opaque = NO;
    self.gridSize = 8;
    self.opacity = 1;
    [self setupLabels];
}

- (void)setupLabels {
    self.horizontalLabel = [self newMiddlePartLabel];
    self.verticalLabel = [self newMiddlePartLabel];
    [self addSubview:self.horizontalLabel];
    [self addSubview:self.verticalLabel];
}

- (UILabel *)newMiddlePartLabel {
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:DBGridOverlayViewLabelFontSize];
    label.textColor = self.colorScheme.primaryColor;
    label.backgroundColor = self.colorScheme.secondaryColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

#pragma mark - Updating frame

- (void)updateFrame {
    self.frame = [UIScreen mainScreen].bounds;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.colorScheme.primaryColor set];
    
    CGFloat lineWidth = 1.0 / [UIScreen mainScreen].scale;

    NSInteger linesPerHalf = self.frame.size.width / (2 * self.gridSize);
    NSInteger screenSize = (NSInteger)self.frame.size.width;
    NSInteger middlePartSize = screenSize - linesPerHalf * 2 * self.gridSize;
    BOOL showsLabel = middlePartSize != 0;
    if (middlePartSize < DBGridOverlayViewMinHorizontalMiddlePartSize && showsLabel) {
        linesPerHalf -= (DBGridOverlayViewMinHorizontalMiddlePartSize - middlePartSize + 2 * self.gridSize - 1) / (2 * self.gridSize);
        middlePartSize = screenSize - linesPerHalf * 2 * self.gridSize;
    }
    
    if (showsLabel) {
        self.horizontalLabel.text = [NSString stringWithFormat:@"%ld", (long)middlePartSize];
        [self.horizontalLabel sizeToFit];
        CGSize labelSize = self.horizontalLabel.frame.size;
        self.horizontalLabel.frame = CGRectMake(linesPerHalf * self.gridSize - lineWidth,
                                                DBGridOverlayViewHorizontalLabelTopOffset,
                                                middlePartSize + 2 * lineWidth,
                                                labelSize.height);
    } else {
        self.horizontalLabel.frame = CGRectZero;
    }

    for (NSInteger lineIndex = 1; lineIndex <= linesPerHalf; lineIndex++) {
        CGContextFillRect(context, CGRectMake(lineIndex * self.gridSize - lineWidth,
                                              0.0,
                                              lineWidth,
                                              self.frame.size.height));
        CGContextFillRect(context, CGRectMake(self.frame.size.width - lineIndex * self.gridSize,
                                              0.0,
                                              lineWidth,
                                              self.frame.size.height));
    }

    linesPerHalf = self.frame.size.height / (2 * self.gridSize);
    screenSize = (NSInteger)self.frame.size.height;
    middlePartSize = screenSize - linesPerHalf * 2 * self.gridSize;
    showsLabel = middlePartSize != 0;
    if (middlePartSize < DBGridOverlayViewMinVerticalMiddlePartSize && showsLabel) {
        linesPerHalf -= (DBGridOverlayViewMinVerticalMiddlePartSize - middlePartSize + 2 * self.gridSize - 1) / (2 * self.gridSize);
        middlePartSize = screenSize - linesPerHalf * 2 * self.gridSize;
    }
    
    if (showsLabel) {
        self.verticalLabel.text = [NSString stringWithFormat:@"%ld", (long)middlePartSize];
        [self.verticalLabel sizeToFit];
        CGSize labelSize = self.verticalLabel.frame.size;
        CGFloat labelWidth = labelSize.width + DBGridOverlayViewVerticalLabelContentOffsets;
        self.verticalLabel.frame = CGRectMake(self.frame.size.width - DBGridOverlayViewVerticalLabelRightOffset - labelWidth,
                                              linesPerHalf * self.gridSize - lineWidth,
                                              labelWidth,
                                              middlePartSize + 2 * lineWidth);
    } else {
        self.verticalLabel.frame = CGRectZero;
    }

    for (NSInteger lineIndex = 1; lineIndex <= linesPerHalf; lineIndex++) {
        CGContextFillRect(context, CGRectMake(0.0,
                                              lineIndex * self.gridSize - lineWidth,
                                              self.frame.size.width,
                                              lineWidth));
        CGContextFillRect(context, CGRectMake(0.0,
                                              self.frame.size.height - lineIndex * self.gridSize,
                                              self.frame.size.width,
                                              lineWidth));
    }
}

#pragma mark - Grid properties

- (void)setGridSize:(NSInteger)gridSize {
    _gridSize = gridSize;
    [self setNeedsDisplay];
}

- (void)setOpacity:(CGFloat)opacity {
    _opacity = opacity;
    self.alpha = opacity;
}

- (void)setColorScheme:(DBGridOverlayColorScheme *)colorScheme {
    _colorScheme = colorScheme;
    self.horizontalLabel.backgroundColor = colorScheme.primaryColor;
    self.horizontalLabel.textColor = colorScheme.secondaryColor;
    self.verticalLabel.backgroundColor = colorScheme.primaryColor;
    self.verticalLabel.textColor = colorScheme.secondaryColor;
    [self setNeedsDisplay];
}

@end
