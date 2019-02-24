//
//  DBJsonViewerMainViewController.m
//  DBDebugToolkit
//
//  Created by Konrad Zdunczyk on 23/02/2019.
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

#import "DBJsonViewerMainViewController.h"
#import "DBJsonViewerHelepr.h"
#import "DBJsonNode.h"

@interface DBJsonViewerMainViewController ()

@property(nonatomic, strong) IBOutlet UINavigationController *navController;

@end

@implementation DBJsonViewerMainViewController

+ (instancetype)jsonViewerWithJson:(id)json {
    DBJsonNode *root = [DBJsonNode jsonNodeWithJson:json];

    if (!root) { return nil; }

    return [[DBJsonViewerMainViewController alloc] initWithJson:root];
}

+ (instancetype)jsonViewerWithJsonString:(NSString *)jsonString {
    DBJsonNode *root = [DBJsonNode jsonNodeWithJsonString:jsonString];

    if (!root) { return nil; }

    return [[DBJsonViewerMainViewController alloc] initWithJson:root];
}

- (instancetype)initWithJson:(DBJsonNode*)node {
    self = [super init];
    if (self) {
        UIViewController *vc = [DBJsonViewerHelepr viewControllerForDBJsonNode:node];
        _navController = [[UINavigationController alloc] initWithRootViewController:vc];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationController];
}

- (void)setupNavigationController {
    [_navController willMoveToParentViewController:self];
    [self addChildViewController:_navController];

    UIView *ncView = _navController.view;

    [self.view addSubview:ncView];
    ncView.translatesAutoresizingMaskIntoConstraints = NO;

    id topItem;
    NSLayoutAttribute topItemAttribute;
    id bottomItem;
    NSLayoutAttribute bottomItemAttribute;
    if (@available(iOS 11.0, *)) {
        topItem = self.view.safeAreaLayoutGuide;
        bottomItem = self.view.safeAreaLayoutGuide;

        topItemAttribute = NSLayoutAttributeTop;
        bottomItemAttribute = NSLayoutAttributeBottom;
    } else {
        topItem = self.topLayoutGuide;
        bottomItem = self.bottomLayoutGuide;

        topItemAttribute = NSLayoutAttributeBottom;
        bottomItemAttribute = NSLayoutAttributeTop;
    }

    NSArray *constraints = @[
    [NSLayoutConstraint constraintWithItem:ncView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0],
    [NSLayoutConstraint constraintWithItem:ncView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:topItem
                                 attribute:topItemAttribute
                                multiplier:1.0
                                  constant:0.0],
    [NSLayoutConstraint constraintWithItem:ncView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0],
    [NSLayoutConstraint constraintWithItem:ncView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:bottomItem
                                 attribute:bottomItemAttribute
                                multiplier:1.0
                                  constant:0.0]
    ];

    [NSLayoutConstraint activateConstraints:constraints];

    [_navController didMoveToParentViewController:self];
}

@end
