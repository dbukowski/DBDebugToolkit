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

#import "DBNetworkViewController.h"
#import "DBRequestTableViewCell.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBNetworkSettingsTableViewController.h"
#import "DBRequestDetailsViewController.h"
#import "NSOperationQueue+DBMainQueueOperation.h"

static NSString *const DBNetworkViewControllerRequestCellIdentifier = @"DBRequestTableViewCell";

@interface DBNetworkViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DBNetworkToolkitDelegate, DBRequestDetailsViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *loggingRequestsDisabledLabel;
@property (nonatomic, strong) NSArray *filteredRequests;
@property (nonatomic, strong) DBRequestDetailsViewController *requestDetailsViewController;
@property (nonatomic, strong) DBRequestModel *openedRequest;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation DBNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.networkToolkit.delegate = self;
    self.filteredRequests = self.networkToolkit.savedRequests;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBRequestTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBNetworkViewControllerRequestCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    [self configureViewWithLoggingRequestsEnabled:self.networkToolkit.loggingEnabled];
    self.operationQueue = [NSOperationQueue new];
    self.operationQueue.maxConcurrentOperationCount = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - Configuring View

- (void)updateRequests {
    NSString *searchBarText = self.searchBar.text;
    if (searchBarText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SELF.url.relativePath contains[cd] %@) OR (SELF.url.host contains[cd] %@)", searchBarText, searchBarText];
        self.filteredRequests = [self.networkToolkit.savedRequests filteredArrayUsingPredicate:predicate];
    } else {
        self.filteredRequests = self.networkToolkit.savedRequests;
    }
}

- (void)reloadData {
    __weak DBNetworkViewController *weakSelf = self;
    [self.operationQueue addMainQueueOperationWithBlock:^{
        __strong DBNetworkViewController *strongSelf = weakSelf;
        [strongSelf updateRequests];
        [strongSelf.tableView reloadData];
    }];
}

- (void)configureViewWithLoggingRequestsEnabled:(BOOL)enabled {
    self.tableView.alpha = enabled ? 1.0 : 0.0;
    self.searchBar.alpha = enabled ? 1.0 : 0.0;
    self.loggingRequestsDisabledLabel.alpha = enabled ? 0.0 : 1.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DBNetworkSettingsTableViewController class]]) {
        DBNetworkSettingsTableViewController *settingsViewController = (DBNetworkSettingsTableViewController *)segue.destinationViewController;
        settingsViewController.networkToolkit = self.networkToolkit;
    }
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets newContentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    self.tableView.contentInset = newContentInsets;
    self.tableView.scrollIndicatorInsets = newContentInsets;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredRequests.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBRequestTableViewCell *requestCell = [tableView dequeueReusableCellWithIdentifier:DBNetworkViewControllerRequestCellIdentifier];
    [requestCell configureWithRequestModel:self.filteredRequests[self.filteredRequests.count - 1 - indexPath.row]];
    return requestCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.openedRequest) {
        DBRequestModel *requestModel = self.filteredRequests[self.filteredRequests.count - 1 - indexPath.row];
        self.openedRequest = requestModel;
        [self.requestDetailsViewController configureWithRequestModel:requestModel];
        [self.navigationController pushViewController:self.requestDetailsViewController animated:YES];
    }
}

- (DBRequestDetailsViewController *)requestDetailsViewController {
    if (!_requestDetailsViewController) {
        NSBundle *bundle = [NSBundle debugToolkitBundle];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBRequestDetailsViewController" bundle:bundle];
        _requestDetailsViewController = [storyboard instantiateInitialViewController];
        _requestDetailsViewController.delegate = self;
    }
    return _requestDetailsViewController;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text.length > 0) {
        [searchBar setText:@""];
        [self reloadData];
    }
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark - DBNetworkToolkitDelegate

- (void)networkDebugToolkitDidUpdateRequestsList:(DBNetworkToolkit *)networkToolkit {
    [self reloadData];
}

- (void)networkDebugToolkit:(DBNetworkToolkit *)networkToolkit didUpdateRequestAtIndex:(NSInteger)index {
    __weak DBNetworkViewController *weakSelf = self;
    [self.operationQueue addMainQueueOperationWithBlock:^{
        __strong DBNetworkViewController *strongSelf = weakSelf;
        DBRequestModel *requestModel = strongSelf.networkToolkit.savedRequests[index];
        if (requestModel == strongSelf.openedRequest) {
            [strongSelf.requestDetailsViewController configureWithRequestModel:requestModel];
        }
        [strongSelf updateRequests];
        NSInteger updatedRequestIndex = [strongSelf.filteredRequests indexOfObject:requestModel];
        if (updatedRequestIndex != NSNotFound) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:strongSelf.filteredRequests.count - 1 - updatedRequestIndex inSection:0];
            DBRequestTableViewCell *requestCell = [strongSelf.tableView cellForRowAtIndexPath:indexPath];
            DBRequestModel *requestModel = strongSelf.filteredRequests[strongSelf.filteredRequests.count - 1 - indexPath.row];
            [requestCell configureWithRequestModel:requestModel];
        }
    }];
}

- (void)networkDebugToolkit:(DBNetworkToolkit *)networkToolkit didSetEnabled:(BOOL)enabled {
    [self configureViewWithLoggingRequestsEnabled:enabled];
}

#pragma mark - DBRequestDetailsViewControllerDelegate

- (void)requestDetailsViewControllerDidDismiss:(DBRequestDetailsViewController *)requestDetailsViewController {
    self.requestDetailsViewController = nil;
    self.openedRequest = nil;
}

@end
