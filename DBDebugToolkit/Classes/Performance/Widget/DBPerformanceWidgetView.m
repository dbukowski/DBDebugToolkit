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

#import "DBPerformanceWidgetView.h"

static const CGFloat DBPerformanceWidgetViewWidth = 220;
static const CGFloat DBPerformanceWidgetViewHeight = 50;
static const CGFloat DBPerformanceWidgetMinimalOffset = 10;

@interface DBPerformanceWidgetView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation DBPerformanceWidgetView

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
    self.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self setupGestureRecognizers];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (!self.superview) {
        self.frame = [self defaultFrameWithSuperview:newSuperview];
    }
}

#pragma mark - Updating frame

- (void)updateFrame {
    CGSize superviewBoundsSize = self.superview.bounds.size;
    CGRect frame = self.frame;
    frame.size.width = DBPerformanceWidgetViewWidth;
    frame.size.height = DBPerformanceWidgetViewHeight;
    frame.origin.x = MIN(superviewBoundsSize.width - frame.size.width - DBPerformanceWidgetMinimalOffset,
                         MAX(DBPerformanceWidgetMinimalOffset, frame.origin.x));
    frame.origin.y = MIN(superviewBoundsSize.height - frame.size.height - DBPerformanceWidgetMinimalOffset,
                         MAX(DBPerformanceWidgetMinimalOffset, frame.origin.y));
    self.frame = frame;
}

- (void)updateFrameWithNewOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
    [self updateFrame];
}

- (CGRect)defaultFrameWithSuperview:(UIView *)superview {
    CGSize superviewBoundsSize = superview.bounds.size;
    CGRect frame = CGRectZero;
    frame.size.width = DBPerformanceWidgetViewWidth;
    frame.size.height = DBPerformanceWidgetViewHeight;
    frame.origin.x = (superviewBoundsSize.width - frame.size.width) / 2;
    frame.origin.y = superviewBoundsSize.height - frame.size.height - DBPerformanceWidgetMinimalOffset;
    return frame;
}

#pragma mark - Gesture recognizers

- (void)setupGestureRecognizers {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint tapLocation = [tapGestureRecognizer locationInView:self];
        DBPerformanceSection tappedSection;
        if (tapLocation.x < self.frame.size.width / 3) {
            tappedSection = DBPerformanceSectionCPU;
        } else if (tapLocation.x < 2 * self.frame.size.width / 3) {
            tappedSection = DBPerformanceSectionMemory;
        } else {
            tappedSection = DBPerformanceSectionFPS;
        }
        [self.delegate performanceWidgetView:self didTapOnSection:tappedSection];
    }
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)panGestureRecognizer {
    static CGPoint previousTouchLocation;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        previousTouchLocation = [panGestureRecognizer locationInView:self.window];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentTouchLocation = [panGestureRecognizer locationInView:self.window];
        CGFloat xDifference = currentTouchLocation.x - previousTouchLocation.x;
        CGFloat yDifference = currentTouchLocation.y - previousTouchLocation.y;
        CGPoint newOrigin = CGPointMake(self.frame.origin.x + xDifference,
                                        self.frame.origin.y + yDifference);
        previousTouchLocation = currentTouchLocation;
        [self updateFrameWithNewOrigin:newOrigin];
    }
}

@end
