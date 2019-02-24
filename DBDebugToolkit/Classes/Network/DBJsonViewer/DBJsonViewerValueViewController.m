//
//  DBJsonViewerValueViewController.m
//  DBDebugToolkit
//
//  Created by Konrad Zdunczyk on 24/02/2019.
//  Copyright © 2019 Konrad Zdunczyk
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

#import "DBJsonViewerValueViewController.h"

@interface DBJsonViewerValueViewController ()

@property(nonatomic, strong) DBJsonNode *node;
@property(nonatomic, strong) UITextView *textView;

@end

@implementation DBJsonViewerValueViewController

- (instancetype)initWithNode:(DBJsonNode*)node {
    self = [super init];
    if (self) {
        _node = node;
        _textView = [[UITextView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextView];

    self.title = [self.node nodeName];
    self.textView.text = [self.node nodeValueDescription];
}

- (void)setupTextView {
    [self.view addSubview:self.textView];
    self.textView.translatesAutoresizingMaskIntoConstraints = NO;
    self.textView.editable = NO;
    self.textView.selectable = YES;
    self.textView.font = [UIFont systemFontOfSize:18];

    NSArray *constraints = @[
                             [NSLayoutConstraint constraintWithItem:self.textView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self.textView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self.textView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self.textView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]
                             ];

    [NSLayoutConstraint activateConstraints:constraints];
}

@end
