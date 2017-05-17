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

@interface _DBBackgroundLayoutIgnoringLayer : CALayer @end
@implementation _DBBackgroundLayoutIgnoringLayer

- (void)layoutSublayers
{
	if([NSThread isMainThread] == NO)
	{
		return;
	}
	
	[super layoutSublayers];
}

@end

@interface _DBBackgroundLayoutIgnoringView : UIView @end
@implementation _DBBackgroundLayoutIgnoringView

+ (Class)layerClass
{
	return [_DBBackgroundLayoutIgnoringLayer class];
}

@end

@interface DBPerformanceWidgetView ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) IBOutlet UIView *cpuValueView;
@property (nonatomic, strong) IBOutlet UIView *memoryValueView;
@property (nonatomic, strong) IBOutlet UIView *fpsValueView;
@property (nonatomic, strong, readwrite) CATextLayer *cpuValueTextLayer;
@property (nonatomic, strong, readwrite) CATextLayer *memoryValueTextLayer;
@property (nonatomic, strong, readwrite) CATextLayer *fpsValueTextLayer;

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
    [self registerForNotifications];
    [self setupGestureRecognizers];
}

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	_cpuValueTextLayer = [CATextLayer layer];
	_cpuValueTextLayer.contentsScale = [UIScreen mainScreen].scale;
	_cpuValueTextLayer.foregroundColor = [UIColor darkGrayColor].CGColor;
	_cpuValueTextLayer.font = (__bridge CFTypeRef)[UIFont systemFontOfSize:14];
	_cpuValueTextLayer.fontSize = 14;
	_cpuValueTextLayer.frame = _cpuValueView.bounds;
	_cpuValueTextLayer.alignmentMode = @"center";
	_cpuValueTextLayer.actions = @{@"contents": [NSNull null]};
	[_cpuValueView.layer addSublayer:_cpuValueTextLayer];
	
	_memoryValueTextLayer = [CATextLayer layer];
	_memoryValueTextLayer.contentsScale = [UIScreen mainScreen].scale;
	_memoryValueTextLayer.foregroundColor = [UIColor darkGrayColor].CGColor;
	_memoryValueTextLayer.font = (__bridge CFTypeRef)[UIFont systemFontOfSize:14];
	_memoryValueTextLayer.fontSize = 14;
	_memoryValueTextLayer.frame = _memoryValueView.bounds;
	_memoryValueTextLayer.alignmentMode = @"center";
	_memoryValueTextLayer.actions = @{@"contents": [NSNull null]};
	[_memoryValueView.layer addSublayer:_memoryValueTextLayer];
	
	_fpsValueTextLayer = [CATextLayer layer];
	_fpsValueTextLayer.contentsScale = [UIScreen mainScreen].scale;
	_fpsValueTextLayer.foregroundColor = [UIColor darkGrayColor].CGColor;
	_fpsValueTextLayer.font = (__bridge CFTypeRef)[UIFont systemFontOfSize:14];
	_fpsValueTextLayer.fontSize = 14;
	_fpsValueTextLayer.frame = _fpsValueView.bounds;
	_fpsValueTextLayer.alignmentMode = @"center";
	_fpsValueTextLayer.actions = @{@"contents": [NSNull null]};
	[_fpsValueView.layer addSublayer:_fpsValueTextLayer];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	_cpuValueTextLayer.frame = _cpuValueView.bounds;
	_memoryValueTextLayer.frame = _memoryValueView.bounds;
	_fpsValueTextLayer.frame = _fpsValueView.bounds;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Adding to window

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (!self.window) {
        // Setting up the default frame.
        self.frame = [self defaultFrameWithWindow:newWindow];
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self updateFrame];
}

#pragma mark - Updating frame

- (void)updateFrame {
    CGSize windowBoundsSize = self.window.bounds.size;
    CGRect frame = self.frame;
    frame.size.width = DBPerformanceWidgetViewWidth;
    frame.size.height = DBPerformanceWidgetViewHeight;
    frame.origin.x = MIN(windowBoundsSize.width - frame.size.width - DBPerformanceWidgetMinimalOffset,
                         MAX(DBPerformanceWidgetMinimalOffset, frame.origin.x));
    frame.origin.y = MIN(windowBoundsSize.height - frame.size.height - DBPerformanceWidgetMinimalOffset,
                         MAX(DBPerformanceWidgetMinimalOffset, frame.origin.y));
    self.frame = frame;
}

- (void)updateFrameWithNewOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
    [self updateFrame];
}

- (CGRect)defaultFrameWithWindow:(UIWindow *)window {
    CGSize windowBoundsSize = window.bounds.size;
    CGRect frame = CGRectZero;
    frame.size.width = DBPerformanceWidgetViewWidth;
    frame.size.height = DBPerformanceWidgetViewHeight;
    frame.origin.x = (windowBoundsSize.width - frame.size.width) / 2;
    frame.origin.y = windowBoundsSize.height - frame.size.height - DBPerformanceWidgetMinimalOffset;
    return frame;
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
        // The widget view was added directly to the window, so it needs custom rotation handling.
        [self updateFrame];
    }
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
