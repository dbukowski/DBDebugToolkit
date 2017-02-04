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

#import "DBRequestDetailsViewController.h"
#import "NSBundle+DBDebugToolkit.h"
#import "DBMenuSegmentedControlTableViewCell.h"
#import "DBTitleValueTableViewCell.h"
#import "DBBodyPreviewViewController.h"

typedef NS_ENUM(NSInteger, DBRequestDetailsViewControllerTab) {
    DBRequestDetailsViewControllerTabRequest,
    DBRequestDetailsViewControllerTabResponse,
    DBRequestDetailsViewControllerTabError
};

static NSString *const DBRequestDetailsViewControllerSegmentedControlCellIdentifier = @"DBMenuSegmentedControlTableViewCell";
static NSString *const DBRequestDetailsViewControllerTitleValueCellIdentifier = @"DBTitleValueTableViewCell";
static NSString *const DBRequestDetailsViewControllerPrototypeSimpleCellIdentifier = @"OpenBodyCell";

@interface DBRequestDetailsViewController () <UITableViewDelegate, UITableViewDataSource, DBMenuSegmentedControlTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DBRequestModel *requestModel;
@property (nonatomic, assign) DBRequestDetailsViewControllerTab selectedTab;
@property (nonatomic, strong) NSArray *requestDetailsDataSources;
@property (nonatomic, strong) NSArray *requestHeaderFieldsDataSources;
@property (nonatomic, strong) NSArray *responseDetailsDataSources;
@property (nonatomic, strong) NSArray *responseHeaderFieldsDataSources;
@property (nonatomic, strong) NSArray *errorDetailsDataSources;

@end

@implementation DBRequestDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBMenuSegmentedControlTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBRequestDetailsViewControllerSegmentedControlCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DBTitleValueTableViewCell" bundle:bundle]
         forCellReuseIdentifier:DBRequestDetailsViewControllerTitleValueCellIdentifier];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.isMovingFromParentViewController) {
        [self.delegate requestDetailsViewControllerDidDismiss:self];
    }
}

- (void)configureWithRequestModel:(DBRequestModel *)requestModel {
    self.requestModel = requestModel;
    [self createDataSources];
    [self.tableView reloadData];
}

#pragma mark - Opening body preview

- (void)openBodyPreview {
    NSBundle *bundle = [NSBundle debugToolkitBundle];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DBBodyPreviewViewController" bundle:bundle];
    DBBodyPreviewViewController *bodyPreviewViewController = [storyboard instantiateInitialViewController];
    DBBodyPreviewViewControllerMode mode = self.selectedTab == DBRequestDetailsViewControllerTabRequest ? DBBodyPreviewViewControllerModeRequest : DBBodyPreviewViewControllerModeResponse;
    [bodyPreviewViewController configureWithRequestModel:self.requestModel mode:mode];
    [self.navigationController pushViewController:bodyPreviewViewController animated:true];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 1) {
        [self openBodyPreview];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 44.0;
        case 3:
            return indexPath.row == 0 ? UITableViewAutomaticDimension : 44.0;
        default:
            return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self heightForFooterAndHeaderInSection:section];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.selectedTab) {
        case DBRequestDetailsViewControllerTabRequest:
            return self.requestModel.requestBodySynchronizationStatus == DBRequestModelBodySynchronizationStatusFinished ? 4 : 3;
        case DBRequestDetailsViewControllerTabResponse:
            return self.requestModel.responseBodySynchronizationStatus == DBRequestModelBodySynchronizationStatusFinished ? 4 : 3;
        case DBRequestDetailsViewControllerTabError:
            return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return [self numberOfRowsInDetailsSection];
        case 2:
            return [self numberOfRowsInHeaderFieldsSection];
        case 3:
            return [self numberOfRowsInBodySection];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            DBMenuSegmentedControlTableViewCell *segmentedControlCell = [tableView dequeueReusableCellWithIdentifier:DBRequestDetailsViewControllerSegmentedControlCellIdentifier];
            [segmentedControlCell configureWithTitles:[self segmentedControlTitles] selectedIndex:[self segmentedControlSelectedIndex]];
            segmentedControlCell.delegate = self;
            return segmentedControlCell;
        }
        case 3: {
            if (indexPath.row == 1) {
                UITableViewCell *openBodyCell = [tableView dequeueReusableCellWithIdentifier:DBRequestDetailsViewControllerPrototypeSimpleCellIdentifier];
                openBodyCell.textLabel.text = @"Body preview";
                return openBodyCell;
            }
        }
        default: {
            return [self titleValueCellWithIndexPath:indexPath];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1:
            return [self firstSectionTitle];
        case 2:
            return [self numberOfRowsInHeaderFieldsSection] > 0 ? @"HTTP header fields" : @"";
        case 3:
            return @"Body";
    }
    
    return nil;
}

#pragma mark - DBMenuSegmentedControlTableViewCellDelegate

- (void)menuSegmentedControlTableViewCell:(DBMenuSegmentedControlTableViewCell *)menuSegmentedControlTableViewCell didSelectSegmentAtIndex:(NSUInteger)index {
    if (index == 0) {
        self.selectedTab = DBRequestDetailsViewControllerTabRequest;
    } else {
        self.selectedTab = self.requestModel.didFinishWithError ? DBRequestDetailsViewControllerTabError : DBRequestDetailsViewControllerTabResponse;
    }
    [self.tableView reloadData];
}

#pragma mark - Private methods

#pragma mark - - Section heights

- (CGFloat)heightForFooterAndHeaderInSection:(NSInteger)section {
    return [self tableView:self.tableView numberOfRowsInSection:section] > 0 ? UITableViewAutomaticDimension : CGFLOAT_MIN;
}

#pragma mark - - Title value cells 

- (DBTitleValueTableViewCell *)titleValueCellWithIndexPath:(NSIndexPath *)indexPath {
    DBTitleValueTableViewCell *titleValueCell = [self.tableView dequeueReusableCellWithIdentifier:DBRequestDetailsViewControllerTitleValueCellIdentifier];
    DBTitleValueTableViewCellDataSource *dataSource = [self titleValueCellDataSourceWithIndexPath:indexPath];
    [titleValueCell configureWithDataSource:dataSource];
    return titleValueCell;
}

- (DBTitleValueTableViewCellDataSource *)titleValueCellDataSourceWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            return [self titleValueDetailsCellDataSourceForRow:indexPath.row];
        case 2:
            return [self titleValueHeaderFieldsCellDataSourceForRow:indexPath.row];
        case 3:
            return [self titleValueBodyCellDataSourceForRow:indexPath.row];
    }
    return nil;
}

- (DBTitleValueTableViewCellDataSource *)titleValueDetailsCellDataSourceForRow:(NSInteger)row {
    switch (self.selectedTab) {
        case DBRequestDetailsViewControllerTabRequest:
            return self.requestDetailsDataSources[row];
        case DBRequestDetailsViewControllerTabResponse:
            return self.responseDetailsDataSources[row];
        case DBRequestDetailsViewControllerTabError:
            return self.errorDetailsDataSources[row];
    }
}

- (DBTitleValueTableViewCellDataSource *)titleValueHeaderFieldsCellDataSourceForRow:(NSInteger)row {
    switch (self.selectedTab) {
        case DBRequestDetailsViewControllerTabRequest:
            return self.requestHeaderFieldsDataSources[row];
        case DBRequestDetailsViewControllerTabResponse:
            return self.responseHeaderFieldsDataSources[row];
        case DBRequestDetailsViewControllerTabError:
            return nil;
    }
}

- (DBTitleValueTableViewCellDataSource *)titleValueBodyCellDataSourceForRow:(NSInteger)row {
    if (row == 0) {
        NSInteger dataLength = self.selectedTab == DBRequestDetailsViewControllerTabResponse ? self.requestModel.responseBodyLength : self.requestModel.requestBodyLength;
        return [DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Body length" value:[@(dataLength) stringValue]];
    }
    
    return nil;
}

#pragma mark - - Data sources

- (void)createDataSources {
    if (self.requestModel.finished) {
        if (self.requestModel.didFinishWithError) {
            [self createErrorDetailsDataSources];
        } else {
            [self createResponseDetailsDataSources];
            self.responseHeaderFieldsDataSources = [self dataSourcesWithHTTPHeaderFields:self.requestModel.allResponseHTTPHeaderFields];
        }
    }
    [self createRequestDetailsDataSources];
    self.requestHeaderFieldsDataSources = [self dataSourcesWithHTTPHeaderFields:self.requestModel.allRequestHTTPHeaderFields];
}

- (void)createRequestDetailsDataSources {
    NSMutableArray *dataSources = [NSMutableArray array];
    [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"URL" value:self.requestModel.url.absoluteString]];
    [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Cache policy" value:[self cachePolicyString]]];
    [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Timeout interval" value:[self stringWithTimeInterval:self.requestModel.timeoutInterval]]];
    [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Sending date" value:[self stringWithDate:self.requestModel.sendingDate]]];
    if (self.requestModel.httpMethod.length > 0) {
        [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"HTTP method" value:self.requestModel.httpMethod]];
    }
    self.requestDetailsDataSources = [dataSources copy];
}

- (void)createResponseDetailsDataSources {
    NSMutableArray *dataSources = [NSMutableArray array];
    [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"MIME type" value:self.requestModel.MIMEType]];
    if (self.requestModel.textEncodingName.length > 0) {
        [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Text encoding name" value:self.requestModel.textEncodingName]];
    }
    [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Receiving date" value:[self stringWithDate:self.requestModel.receivingDate]]];
    [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Duration" value:[self stringWithTimeInterval:self.requestModel.duration]]];
    if (self.requestModel.statusCode != nil) {
        NSString *statusCodeString = [NSString stringWithFormat:@"%@ - %@", self.requestModel.statusCode, self.requestModel.localizedStatusCodeString];
        [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"HTTP status code" value:statusCodeString]];
    }
    self.responseDetailsDataSources = [dataSources copy];
}

- (void)createErrorDetailsDataSources {
    self.errorDetailsDataSources =  @[
        [DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Error code" value:[@(self.requestModel.errorCode) stringValue]],
        [DBTitleValueTableViewCellDataSource dataSourceWithTitle:@"Error description" value:self.requestModel.localizedErrorDescription]
    ];
}

- (NSArray *)dataSourcesWithHTTPHeaderFields:(NSDictionary<NSString *, NSString *> *)headerFields {
    NSMutableArray *dataSources = [NSMutableArray array];
    for (NSString *key in headerFields.allKeys) {
        [dataSources addObject:[DBTitleValueTableViewCellDataSource dataSourceWithTitle:key value:headerFields[key]]];
    }
    return [dataSources copy];
}

#pragma mark - - Number of rows

- (NSInteger)numberOfRowsInDetailsSection {
    switch (self.selectedTab) {
        case DBRequestDetailsViewControllerTabRequest:
            return self.requestDetailsDataSources.count;
        case DBRequestDetailsViewControllerTabResponse:
            return self.responseDetailsDataSources.count;
        case DBRequestDetailsViewControllerTabError:
            return self.errorDetailsDataSources.count;
    }
}

- (NSInteger)numberOfRowsInHeaderFieldsSection {
    switch (self.selectedTab) {
        case DBRequestDetailsViewControllerTabRequest:
            return self.requestModel.allRequestHTTPHeaderFields.count;
        case DBRequestDetailsViewControllerTabResponse:
            return self.requestModel.allResponseHTTPHeaderFields.count;
        case DBRequestDetailsViewControllerTabError:
            return 0;
    }
}

- (NSInteger)numberOfRowsInBodySection {
    switch (self.selectedTab) {
        case DBRequestDetailsViewControllerTabRequest: {
            if (self.requestModel.requestBodySynchronizationStatus == DBRequestModelBodySynchronizationStatusFinished) {
                return self.requestModel.requestBodyLength > 0 ? 2 : 1;
            }
            return 0;
        }
        case DBRequestDetailsViewControllerTabResponse: {
            if (self.requestModel.responseBodySynchronizationStatus == DBRequestModelBodySynchronizationStatusFinished) {
                return self.requestModel.responseBodyLength > 0 ? 2 : 1;
            }
            return 0;
        }
        case DBRequestDetailsViewControllerTabError:
            return 0;
            
    }
}

#pragma mark - - Section title

- (NSString *)firstSectionTitle {
    switch (self.selectedTab) {
        case DBRequestDetailsViewControllerTabRequest:
            return @"Request";
        case DBRequestDetailsViewControllerTabResponse:
            return @"Response";
        case DBRequestDetailsViewControllerTabError:
            return @"Error";
    }
}

#pragma mark - - Value strings

- (NSString *)cachePolicyString {
    switch (self.requestModel.cachePolicy) {
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return @"Reload ignoring local and remote cache data";
        case NSURLRequestReloadIgnoringLocalCacheData:
            return @"Reload ignoring local cache data";
        case NSURLRequestReturnCacheDataElseLoad:
            return @"Return cache data else load";
        case NSURLRequestReloadRevalidatingCacheData:
            return @"Reload revalidating cache data";
        case NSURLRequestReturnCacheDataDontLoad:
            return @"Return cache data, don't load";
        case NSURLRequestUseProtocolCachePolicy:
            return @"Use protocol cache policy";
    }
}

- (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval {
    return [NSString stringWithFormat:@"%.2lfs", timeInterval];
}

- (NSString *)stringWithDate:(NSDate *)date {
    return [NSDateFormatter localizedStringFromDate:date
                                          dateStyle:NSDateFormatterMediumStyle
                                          timeStyle:NSDateFormatterMediumStyle];
}

#pragma mark - - Segmented control

- (NSArray *)segmentedControlTitles {
    NSMutableArray *titles = [NSMutableArray arrayWithObject:@"Request"];
    if (self.requestModel.finished) {
        [titles addObject:self.requestModel.didFinishWithError ? @"Error" : @"Response"];
    }
    return [titles copy];
}

- (NSInteger)segmentedControlSelectedIndex {
    return self.selectedTab == DBRequestDetailsViewControllerTabRequest ? 0 : 1;
}

@end
