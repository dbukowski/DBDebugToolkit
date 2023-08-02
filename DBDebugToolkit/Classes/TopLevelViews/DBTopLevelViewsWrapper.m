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

#import "DBTopLevelViewsWrapper.h"

@interface DBTopLevelViewsWrapper () <DBTopLevelViewDelegate>

@property (nonatomic, strong) NSMutableArray <DBTopLevelView *> *topLevelViews;

@end

@implementation DBTopLevelViewsWrapper

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
    self.backgroundColor = [UIColor clearColor];
    self.topLevelViews = [NSMutableArray array];
    [self updateFrame];
    [self registerForNotifications];
    [self updateVisibility];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil) {
            return YES;
        }
    }
    return NO;
}

- (void)updateVisibility {
    BOOL shouldBeVisible = NO;
    for (UIView *subview in self.subviews) {
        BOOL isSubviewVisible = !subview.isHidden;
        shouldBeVisible |= isSubviewVisible;
    }
    self.hidden = !shouldBeVisible;
}

#pragma mark - Adding views

- (void)addTopLevelView:(DBTopLevelView *)topLevelView {
    topLevelView.topLevelViewDelegate = self;
    [self.topLevelViews addObject:topLevelView];
    [self addSubview:topLevelView];
}

#pragma mark - Updating frame

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self updateFrame];
}

- (void)updateFrame {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
}

#pragma mark - Rotation notifications

- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceDidChangeOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)deviceDidChangeOrientation:(NSNotification *)notification {
    if ([self.superview isKindOfClass:[UIWindow class]]) {
        // The top level views wrapper was added directly to the window, so it needs custom rotation handling.
        [self updateFrame];
        for (DBTopLevelView *topLevelView in self.topLevelViews) {
            [topLevelView updateFrame];
        }
    }
}

#pragma mark - DBTopLevelViewDelegate

- (void)topLevelViewDidUpdateVisibility:(DBTopLevelView *)topLevelView {
    [self updateVisibility];
}

@end
