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

#import "DBRequestModel.h"

@interface DBRequestModel ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, copy) NSString *httpMethod;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *allRequestHTTPHeaderFields;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, strong) NSDate *sendingDate;
@property (nonatomic, strong) NSDate *receivingDate;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSInteger httpRequestBodyLength;
@property (nonatomic, assign) NSInteger httpResponseBodyLength;
@property (nonatomic, assign) DBRequestModelBodySynchronizationStatus requestBodySynchronizationStatus;
@property (nonatomic, assign) DBRequestModelBodySynchronizationStatus responseBodySynchronizationStatus;
@property (nonatomic, copy) void (^readingRequestBodyCompletion)(NSData *);
@property (nonatomic, copy) void (^readingResponseBodyCompletion)(NSData *);
@property (nonatomic, strong) UIImage *thumbnail;

@end

@implementation DBRequestModel

#pragma mark - Initialization

- (instancetype)initWithRequest:(NSURLRequest *)request {
    self = [super init];
    if (self) {
        _url = request.URL;
        self.cachePolicy = request.cachePolicy;
        self.timeoutInterval = request.timeoutInterval;
        _httpMethod = request.HTTPMethod;
        _allRequestHTTPHeaderFields = request.allHTTPHeaderFields;
        _sendingDate = [NSDate date];
        [self saveRequestBody:request.HTTPBody];
    }
    
    return self;
}

+ (instancetype)requestModelWithRequest:(NSURLRequest *)request {
    return [[self alloc] initWithRequest:request];
}

#pragma mark - Saving outcome

- (void)saveOutcome:(DBRequestOutcome *)requestOutcome {
    if (requestOutcome.error != nil) {
        [self saveError:requestOutcome.error];
    } else {
        [self saveResponse:requestOutcome.response data:requestOutcome.data];
    }
}

- (void)saveError:(NSError *)error {
    [self finish];
    self.error = error;
}

- (void)saveResponse:(NSURLResponse *)response data:(NSData *)data {
    [self finish];
    self.response = response;
    [self saveResponseBody:data];
}

- (void)finish {
    self.finished = true;
    self.receivingDate = [NSDate date];
    self.duration = [self.receivingDate timeIntervalSinceDate:self.sendingDate];
}

#pragma mark - Saving body

- (NSString *)requestBodyFilename {
    return [NSString stringWithFormat:@"Request_%@_%@", self.url, @(self.sendingDate.timeIntervalSince1970)];
}

- (NSString *)responseBodyFilename {
    return [NSString stringWithFormat:@"Response_%@_%@", self.url, @(self.receivingDate.timeIntervalSince1970)];
}

- (NSString *)pathForFileWithName:(NSString *)filename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"DBDebugToolkit/Network/%@", filename]];
}

- (void)saveData:(NSData *)data toFileWithName:(NSString *)filename withCompletion:(void(^)())completion {
    NSString *filePath = [self pathForFileWithName:filename];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [data writeToFile:filePath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completion) {
                completion();
            }
        });
    });
}

- (void)saveRequestBody:(NSData *)data {
    self.httpRequestBodyLength = data.length;
    self.requestBodySynchronizationStatus = DBRequestModelBodySynchronizationStatusStarted;
    if (self.httpRequestBodyLength > 0) {
        __weak DBRequestModel *weakSelf = self;
        [self saveData:data toFileWithName:[self requestBodyFilename] withCompletion:^{
            DBRequestModel *strongSelf = weakSelf;
            strongSelf.requestBodySynchronizationStatus = DBRequestModelBodySynchronizationStatusFinished;
            if (strongSelf.readingRequestBodyCompletion) {
                strongSelf.readingRequestBodyCompletion(data);
            }
        }];
    } else {
        self.requestBodySynchronizationStatus = DBRequestModelBodySynchronizationStatusFinished;
        if (self.readingRequestBodyCompletion) {
            self.readingRequestBodyCompletion(nil);
        }
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)generateThumbnailFromData:(NSData *)data withCompletion:(void(^)())completion {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            self.thumbnail = [self imageWithImage:image scaledToSize:CGSizeMake(50, 50)];
        }
        if (completion) {
            completion();
        }
    });
}

- (void)saveResponseBody:(NSData *)data {
    self.httpResponseBodyLength = data.length;
    self.responseBodySynchronizationStatus = DBRequestModelBodySynchronizationStatusStarted;
    if (self.httpResponseBodyLength > 0) {
        [self generateThumbnailFromData:data withCompletion:^{
            __weak DBRequestModel *weakSelf = self;
            [self saveData:data toFileWithName:[self responseBodyFilename] withCompletion:^{
                DBRequestModel *strongSelf = weakSelf;
                strongSelf.responseBodySynchronizationStatus = DBRequestModelBodySynchronizationStatusFinished;
                if (strongSelf.readingResponseBodyCompletion) {
                    strongSelf.readingResponseBodyCompletion(data);
                }
            }];
        }];
    } else {
        self.responseBodySynchronizationStatus = DBRequestModelBodySynchronizationStatusFinished;
        if (self.readingResponseBodyCompletion) {
            self.readingResponseBodyCompletion(nil);
        }
    }
}

#pragma mark - Accessing saved body

- (void)readDataFromFileWithName:(NSString *)filename withCompletion:(void(^)(NSData *))completion {
    NSString *filePath = [self pathForFileWithName:filename];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completion) {
                completion(data);
            }
        });
    });
}

- (void)readRequestBodyWithCompletion:(void (^)(NSData *))completion {
    if (self.requestBodySynchronizationStatus != DBRequestModelBodySynchronizationStatusFinished) {
        // Store the completion block and run it after saving data.
        self.readingRequestBodyCompletion = completion;
    } else {
        [self readDataFromFileWithName:[self requestBodyFilename] withCompletion:completion];
    }
}

- (void)readResponseBodyWithCompletion:(void (^)(NSData *))completion {
    if (self.responseBodySynchronizationStatus != DBRequestModelBodySynchronizationStatusFinished) {
        // Store the completion block and run it after saving data.
        self.readingResponseBodyCompletion = completion;
    } else {
        [self readDataFromFileWithName:[self responseBodyFilename] withCompletion:completion];
    }
}

#pragma mark - Response properties

- (NSHTTPURLResponse *)httpURLResponse {
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return (NSHTTPURLResponse *)self.response;
    }
    return nil;
}

- (NSString *)MIMEType {
    return self.response.MIMEType;
}

- (NSString *)textEncodingName {
    return self.response.textEncodingName;
}

- (NSInteger)statusCode {
    return [self httpURLResponse].statusCode;
}

- (NSString *)localizedStatusCodeString {
    return [NSHTTPURLResponse localizedStringForStatusCode:self.statusCode];
}

- (NSDictionary<NSString *, NSString *> *)allResponseHTTPHeaderFields {
    return [self httpURLResponse].allHeaderFields;
}

#pragma mark - Error properties

- (NSInteger)errorCode {
    return self.error.code;
}

- (NSString *)localizedDescription {
    return self.error.localizedDescription;
}

@end
