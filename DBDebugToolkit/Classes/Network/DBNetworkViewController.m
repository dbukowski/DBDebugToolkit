//
//  DBNetworkViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 17.01.2017.
//
//

#import "DBNetworkViewController.h"
#import "DBRequestTableViewCell.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBNetworkSettingsTableViewController.h"

static NSString *const DBNetworkViewControllerRequestCellIdentifier = @"DBRequestTableViewCell";

@interface DBNetworkViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DBNetworkToolkitDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *loggingRequestsDisabledLabel;
@property (nonatomic, strong) NSArray *filteredRequests;

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
    [self updateRequests];
    [self.tableView reloadData];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

- (void)networkDebugToolkit:(DBNetworkToolkit *)networkToolkit didUpdateRequestAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        DBRequestModel *requestModel = self.networkToolkit.savedRequests[index];
        [self updateRequests];
        NSInteger updatedRequestIndex = [self.filteredRequests indexOfObject:requestModel];
        if (updatedRequestIndex != NSNotFound) {
            [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:self.filteredRequests.count - 1 - updatedRequestIndex inSection:0] ]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    });
}

- (void)networkDebugToolkit:(DBNetworkToolkit *)networkToolkit didSetEnabled:(BOOL)enabled {
    [self configureViewWithLoggingRequestsEnabled:enabled];
}

@end
