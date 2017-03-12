//
//  DBRequestsExampleViewController.m
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 04.02.2017.
//  Copyright © 2017 Dariusz Bukowski. All rights reserved.
//

#import "DBRequestsExampleViewController.h"
#import "DBRequestExampleTableViewCell.h"

@interface DBRequestsExampleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) NSArray *cellImages;
@property (nonatomic, strong) NSOperationQueue *imageOperationQueue;

@end

@implementation DBRequestsExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DBRequestExampleTableViewCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"ImageCell"];
    self.imageOperationQueue = [[NSOperationQueue alloc] init];
    self.imageOperationQueue.maxConcurrentOperationCount = 5;
    [self getExampleData];
}

#pragma mark - Fetching data

- (void)getExampleData {
    NSString *urlString = @"https://jsonplaceholder.typicode.com/photos";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    __weak DBRequestsExampleViewController *weakSelf = self;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong DBRequestsExampleViewController *strongSelf = weakSelf;
        if(!error){
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSMutableArray *images = [NSMutableArray array];
            NSMutableArray *titles = [NSMutableArray array];
            for (NSDictionary *responseDictionary in responseArray) {
                [images addObject:responseDictionary[@"thumbnailUrl"]];
                [titles addObject:responseDictionary[@"title"]];
            }
            strongSelf.cellImages = images;
            strongSelf.cellTitles = titles;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.tableView reloadData];
            });
        }
    }] resume];
}

- (void)getImageWithURLString:(NSString *)urlString completion:(void (^)(UIImage *))completion {
    NSLog(@"Logging example: getting image from %@...", urlString);
    NSCache *cache = [DBRequestsExampleViewController imagesCache];
    [self.imageOperationQueue addOperationWithBlock:^{
        UIImage *image = [cache objectForKey:urlString];
        if(!image){
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            image = [UIImage imageWithData:data];
            if(image){
                [cache setObject:image forKey:urlString];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion){
                completion(image);
            }
        });
    }];
}

+ (NSCache *)imagesCache {
    static NSCache *imagesCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagesCache = [[NSCache alloc] init];
    });
    return imagesCache;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBRequestExampleTableViewCell *cell = (DBRequestExampleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
    cell.thumbnailImageView.image = nil;
    cell.tag = indexPath.row;
    [self getImageWithURLString:self.cellImages[indexPath.row] completion:^(UIImage *image) {
        if(cell.tag == indexPath.row){
            cell.thumbnailImageView.image = image;
        }
    }];
    cell.titleLabel.text = self.cellTitles[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellImages.count;
}

@end
