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

#import "DBSliderTableViewCell.h"

@interface DBSliderTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *valueLabel;
@property (nonatomic, weak) IBOutlet UISlider *slider;

@end

@implementation DBSliderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.slider addTarget:self action:@selector(sliderValueChanged:event:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - UISlider properties

- (void)setValue:(NSInteger)value {
    self.slider.value = (NSInteger)value;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
}

- (void)setMinValue:(NSInteger)minValue {
    self.slider.minimumValue = (NSInteger)minValue;
}

- (void)setMaxValue:(NSInteger)maxValue {
    self.slider.maximumValue = (NSInteger)maxValue;
}

#pragma mark - UISlider callbacks

- (void)sliderValueChanged:(id)sender event:(UIEvent*)event {
    UITouch *touchEvent = event.allTouches.anyObject;
    switch (touchEvent.phase) {
        case UITouchPhaseBegan:
            [self.delegate sliderCellDidStartEditingValue:self];
            break;
        case UITouchPhaseEnded:
            [self.delegate sliderCellDidEndEditingValue:self];
            break;
        default:
            break;
    }
    NSInteger value = (NSInteger)self.slider.value;
    self.valueLabel.text = [NSString stringWithFormat:@"%ld", (long)value];
    [self.delegate sliderCell:self didSelectValue:value];
}

@end
