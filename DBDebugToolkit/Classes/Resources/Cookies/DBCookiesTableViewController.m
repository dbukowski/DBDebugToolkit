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

#import "DBCookiesTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "UILabel+DBDebugToolkit.h"
#import "DBCookieTableViewCell.h"
#import "DBCookieDetailsTableViewController.h"

static NSString *const DBCookiesTableViewControllerCookieCellIdentifier = @"DBCookieTableViewCell";

@interface DBCookiesTableViewController () <DBCookieDetailsTableViewControllerDelegate>

@property (nonatomic, strong) UILabel *backgroundLabel;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *clearButton;
@property (nonatomic, strong) NSMutableArray *cookies;

@end

@implementation DBCookiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies mutableCopy];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBCookieTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBCookiesTableViewControllerCookieCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    [self setupBackgroundLabel];
}

- (void)setupBackgroundLabel {
    self.backgroundLabel = [UILabel tableViewBackgroundLabel];
    self.tableView.backgroundView = self.backgroundLabel;
}

#pragma mark - Clear button

- (IBAction)clearButtonAction:(id)sender {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in self.cookies) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.cookies removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = self.cookies.count;
    self.backgroundLabel.text = numberOfRows == 0 ? @"There are no HTTP cookies." : @"";
    self.clearButton.enabled = numberOfRows > 0;
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBCookieTableViewCell *cookieTableViewCell = [self.tableView dequeueReusableCellWithIdentifier:DBCookiesTableViewControllerCookieCellIdentifier];
    NSHTTPCookie *cookie = self.cookies[indexPath.row];
    cookieTableViewCell.nameLabel.text = cookie.name;
    cookieTableViewCell.domainLabel.text = cookie.domain;
    return cookieTableViewCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSHTTPCookie *cookie = self.cookies[indexPath.row];
        [cookieStorage deleteCookie:cookie];
        [self.cookies removeObject:cookie];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSHTTPCookie *cookie = self.cookies[indexPath.row];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBCookieDetailsTableViewController" bundle:bundle];
    DBCookieDetailsTableViewController *cookieDetailsTableViewController = [storyboard instantiateInitialViewController];
    cookieDetailsTableViewController.cookie = cookie;
    cookieDetailsTableViewController.delegate = self;
    [self.navigationController pushViewController:cookieDetailsTableViewController animated:YES];
}

#pragma mark - DBCookieDetailsTableViewControllerDelegate

- (void)cookieDetailsTableViewController:(DBCookieDetailsTableViewController *)cookieDetailsTableViewController didTapDeleteWithCookie:(NSHTTPCookie *)cookie {
    [self.cookies removeObject:cookie];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
