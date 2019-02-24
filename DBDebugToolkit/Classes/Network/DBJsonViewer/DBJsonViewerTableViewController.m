//
//  DBJsonViewerTableViewController.m
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

#import "DBJsonViewerTableViewController.h"
#import "DBJsonViewerHelepr.h"
#import "DBJsonViewerTableViewCell.h"
#import "NSBundle+DBDebugToolkit.h"

static NSString *const DBJsonViewerTableViewCellCellIdentifier = @"DBJsonViewerTableViewCell";

@interface DBJsonViewerTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) DBJsonNode *node;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation DBJsonViewerTableViewController

- (instancetype)initWithNode:(DBJsonNode*)node {
    self = [super init];
    if (self) {
        _node = node;
        _tableView = [[UITableView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [self.node nodeName];
    [self setupTableView];
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    NSArray *constraints = @[
                             [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0],
                             [NSLayoutConstraint constraintWithItem:self.tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]
                             ];

    [NSLayoutConstraint activateConstraints:constraints];

    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBJsonViewerTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBJsonViewerTableViewCellCellIdentifier];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    DBJsonViewerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DBJsonViewerTableViewCellCellIdentifier
                                                                      forIndexPath:indexPath];

    NSArray *subnodes = self.node.value;
    DBJsonNode *subnode = subnodes[indexPath.row];

    [cell setupWithNode:subnode];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.node.jsonNodeType) {
        case DBJsonNodeTypeNull:
        case DBJsonNodeTypeString:
        case DBJsonNodeTypeNumber:
        case DBJsonNodeTypeBool:
            return 0;
        case DBJsonNodeTypeObject:
        case DBJsonNodeTypeArray: {
            NSArray *subnodes = self.node.value;

            return subnodes.count;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSArray *subnodes = self.node.value;
    DBJsonNode *subnode = subnodes[indexPath.row];

    UIViewController *vc = [DBJsonViewerHelepr viewControllerForDBJsonNode:subnode];
    if (vc) {
        [self showViewController:vc sender:nil];
    }
}

@end
