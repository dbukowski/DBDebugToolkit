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

#import "DBChartView.h"

static const CGFloat DBChartViewSpaceForMarkedValue = 30;
static const CGFloat DBChartViewAdditionalLinesDistanceFromAxis = 4;
static const CGFloat DBChartViewMarkedValueDistanceFromAxis = 4;
static const CGFloat DBChartViewOffsetFromArrows = 8;
static const CGFloat DBChartViewArrowWidth = 2;
static const CGFloat DBChartViewArrowHeight = 4;

@implementation DBChartView

- (void)setMeasurements:(NSArray *)measurements {
    _measurements = measurements;
    [self setNeedsDisplay];
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    self.measurements = @[ @10, @20, @30, @25, @20, @15, @16, @10];
    self.maxValue = 35.0;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint chartStartPoint = CGPointMake(DBChartViewSpaceForMarkedValue + DBChartViewAdditionalLinesDistanceFromAxis + DBChartViewMarkedValueDistanceFromAxis,
                                          rect.size.height - DBChartViewAdditionalLinesDistanceFromAxis);
    CGPoint topRightChartCorner = CGPointMake(rect.size.width - DBChartViewOffsetFromArrows - DBChartViewAdditionalLinesDistanceFromAxis,
                                              DBChartViewOffsetFromArrows + DBChartViewAdditionalLinesDistanceFromAxis);
    
    if (self.measurements.count > 1) {
        // Drawing chart.
        CGContextSetStrokeColorWithColor(context, self.chartColor.CGColor);
        CGContextSetLineJoin(context, kCGLineJoinMiter);
        CGContextMoveToPoint(context, chartStartPoint.x, chartStartPoint.y);
        CGFloat oneMeasurementWidth = (topRightChartCorner.x - chartStartPoint.x) / (self.measurementsLimit - 1);
        for (int index = 0; index < self.measurements.count; index++) {
            CGFloat measurement = [self.measurements[index] doubleValue];
            CGFloat measurementY = chartStartPoint.y - measurement * (chartStartPoint.y - topRightChartCorner.y) / self.maxValue;
            CGContextAddLineToPoint(context, chartStartPoint.x + oneMeasurementWidth * index, measurementY);
        }
        if (self.filled) {
            CGContextSetFillColorWithColor(context, self.chartColor.CGColor);
            CGContextAddLineToPoint(context, chartStartPoint.x + oneMeasurementWidth * (self.measurements.count - 1), chartStartPoint.y);
            CGContextAddLineToPoint(context, chartStartPoint.x, chartStartPoint.y);
            CGContextFillPath(context);
        }
        CGContextStrokePath(context);
    }
    
    // Drawing axes on top of the chart.
    CGContextSetStrokeColorWithColor(context, self.axisColor.CGColor);
    
    // Drawing x-axis.
    CGContextMoveToPoint(context, chartStartPoint.x, chartStartPoint.y);
    CGContextAddLineToPoint(context, rect.size.width, chartStartPoint.y);
    CGContextAddLineToPoint(context, rect.size.width - DBChartViewArrowHeight,
                            chartStartPoint.y + DBChartViewArrowWidth);
    CGContextAddLineToPoint(context, rect.size.width, chartStartPoint.y);
    CGContextAddLineToPoint(context, rect.size.width - DBChartViewArrowHeight,
                            chartStartPoint.y - DBChartViewArrowWidth);
    CGContextStrokePath(context);
    
    // Drawing y-axis.
    CGContextMoveToPoint(context, chartStartPoint.x, chartStartPoint.y);
    CGContextAddLineToPoint(context, chartStartPoint.x, 0);
    CGContextAddLineToPoint(context, chartStartPoint.x - DBChartViewArrowWidth, DBChartViewArrowHeight);
    CGContextAddLineToPoint(context, chartStartPoint.x, 0);
    CGContextAddLineToPoint(context, chartStartPoint.x + DBChartViewArrowWidth, DBChartViewArrowHeight);
    CGContextStrokePath(context);
    
    // Drawing marked value line.
    CGFloat markedValueY = chartStartPoint.y - self.markedValue * (chartStartPoint.y - topRightChartCorner.y) / self.maxValue;
    CGContextMoveToPoint(context, chartStartPoint.x, markedValueY);
    CGContextAddLineToPoint(context, chartStartPoint.x + DBChartViewAdditionalLinesDistanceFromAxis, markedValueY);
    CGContextAddLineToPoint(context, chartStartPoint.x - DBChartViewAdditionalLinesDistanceFromAxis, markedValueY);
    CGContextStrokePath(context);
    
    // Drawing marked value.
    UIFont *font = [UIFont systemFontOfSize:8];
    NSDictionary *stringAttributes = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : self.axisColor };
    NSString *markedValueString = [NSString stringWithFormat:self.markedValueFormat, self.markedValue];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:markedValueString attributes:stringAttributes];
    CGSize attributedStringSize = attributedString.size;
    [attributedString drawInRect:CGRectMake(chartStartPoint.x - DBChartViewAdditionalLinesDistanceFromAxis - DBChartViewMarkedValueDistanceFromAxis - attributedStringSize.width,
                                            markedValueY - attributedStringSize.height / 2,
                                            attributedStringSize.width,
                                            attributedStringSize.height)];
}

@end
