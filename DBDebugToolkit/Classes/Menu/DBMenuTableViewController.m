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

#import "DBMenuTableViewController.h"
#import "DBPerformanceTableViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBConsoleViewController.h"
#import "DBNetworkViewController.h"
#import "DBUserInterfaceTableViewController.h"

@interface DBMenuTableViewController ()

@end

@implementation DBMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Close button

- (IBAction)closeButtonAction:(id)sender {
    [self.delegate menuTableViewControllerDidTapClose:self];
}

#pragma mark - Opening Performance menu

- (void)openPerformanceMenuWithSection:(DBPerformanceSection)section animated:(BOOL)animated {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBPerformanceTableViewController" bundle:bundle];
    DBPerformanceTableViewController *performanceTableViewController = [storyboard instantiateInitialViewController];
    performanceTableViewController.performanceToolkit = self.performanceToolkit;
    performanceTableViewController.selectedSection = section;
    [self.navigationController setViewControllers:@[ self, performanceTableViewController ] animated:animated];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        // Open application settings.
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.buildInfoProvider buildInfoString];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.deviceInfoProvider deviceInfoString];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destinationViewController = [segue destinationViewController];
    if ([destinationViewController isKindOfClass:[DBPerformanceTableViewController class]]) {
        DBPerformanceTableViewController *performanceTableViewController = (DBPerformanceTableViewController *)destinationViewController;
        performanceTableViewController.performanceToolkit = self.performanceToolkit;
    } else if ([destinationViewController isKindOfClass:[DBConsoleViewController class]]) {
        DBConsoleViewController *consoleViewController = (DBConsoleViewController *)destinationViewController;
        consoleViewController.consoleOutputCaptor = self.consoleOutputCaptor;
        consoleViewController.buildInfoProvider = self.buildInfoProvider;
        consoleViewController.deviceInfoProvider = self.deviceInfoProvider;
    } else if ([destinationViewController isKindOfClass:[DBNetworkViewController class]]) {
        DBNetworkViewController *networkViewController = (DBNetworkViewController *)destinationViewController;
        networkViewController.networkToolkit = self.networkToolkit;
    } else if ([destinationViewController isKindOfClass:[DBUserInterfaceTableViewController class]]) {
        DBUserInterfaceTableViewController *userInterfaceTableViewController = (DBUserInterfaceTableViewController *)destinationViewController;
        userInterfaceTableViewController.userInterfaceToolkit = self.userInterfaceToolkit;
    }
}

@end
