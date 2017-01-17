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

#import "DBNetworkToolkit.h"
#import "DBURLProtocol.h"
#import "DBRequestModel.h"

@interface DBNetworkToolkit ()

@property (nonatomic, copy) NSMutableArray *savedRequests;
@property (nonatomic, strong) NSMapTable *runningRequestsModels;

@end

@implementation DBNetworkToolkit

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self resetLoggedData];
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static DBNetworkToolkit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBNetworkToolkit alloc] init];
        [self setupURLProtocol];
    });
    return sharedInstance;
}

+ (void)setupURLProtocol {
    [NSURLProtocol registerClass:[DBURLProtocol class]];
}

#pragma mark - Logging settings 

- (void)setLoggingEnabled:(BOOL)loggingEnabled {
    _loggingEnabled = loggingEnabled;
    if (!loggingEnabled) {
        [self resetLoggedData];
    }
}

- (void)resetLoggedData {
    _savedRequests = [NSMutableArray array];
    _runningRequestsModels = [NSMapTable weakToWeakObjectsMapTable];
    [self removeOldSavedRequests];
}

#pragma mark - Saving request data

- (void)removeOldSavedRequests {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [self savedRequestsPath];
    NSError *error = nil;
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
        NSString *filePath = [directory stringByAppendingPathComponent:file];
        [fileManager removeItemAtPath:filePath error:&error];
    }
}

- (NSString *)savedRequestsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"DBDebugToolkit/Network"];
}

- (void)saveRequest:(NSURLRequest *)request {
    DBRequestModel *requestModel = [DBRequestModel requestModelWithRequest:request];
    [self.runningRequestsModels setObject:requestModel forKey:request];
    [self.savedRequests addObject:requestModel];
}

- (void)saveRequestOutcome:(DBRequestOutcome *)requestOutcome forRequest:(NSURLRequest *)request {
    DBRequestModel *requestModel = [self.runningRequestsModels objectForKey:request];
    [requestModel saveOutcome:requestOutcome];
    [self.runningRequestsModels removeObjectForKey:request];
}

@end
