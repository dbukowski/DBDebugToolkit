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

static NSString *const DBNetworkViewControllerRequestCellIdentifier = @"DBRequestTableViewCell";

@interface DBNetworkViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, DBNetworkToolkitDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

#pragma mark - DBNetworkToolkitDelegate

- (void)networkDebugToolkitDidUpdateRequestsList:(DBNetworkToolkit *)networkToolkit {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.filteredRequests = networkToolkit.savedRequests;
        [self.tableView reloadData];
    });
}

- (void)networkDebugToolkit:(DBNetworkToolkit *)networkToolkit didUpdateRequestAtIndex:(NSInteger)index {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.filteredRequests = networkToolkit.savedRequests;
        [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:self.filteredRequests.count - 1 - index inSection:0] ]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    });
}

- (void)networkDebugToolkit:(DBNetworkToolkit *)networkToolkit didSetEnabled:(BOOL)enabled {
    
}

@end
