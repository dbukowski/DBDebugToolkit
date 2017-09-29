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

#import "DBRequestDataHandler.h"
#import "DBNetworkToolkit.h"

static CGSize const DBRequestDataHandlerThumbnailSize = { 50, 50 };

@interface DBRequestDataHandler ()

@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) void (^readingCompletion)(NSData *);
@property (nonatomic, assign) DBRequestModelBodyType dataType;
@property (nonatomic, assign) DBRequestModelBodySynchronizationStatus synchronizationStatus;
@property (nonatomic, assign) NSInteger dataLength;

@end

@implementation DBRequestDataHandler

#pragma mark - Initialization

- (instancetype)initWithFilename:(NSString *)filename data:(NSData *)data shouldGenerateThumbnail:(BOOL)shouldGenerateThumbnail {
    self = [super init];
    if (self) {
        self.filename = filename;
        [self saveData:data shouldGenerateThumbnail:shouldGenerateThumbnail];
    }
    
    return self;
}

+ (instancetype)dataHandlerWithFilename:(NSString *)filename data:(NSData *)data shouldGenerateThumbnail:(BOOL)shouldGenerateThumbnail {
    return [[self alloc] initWithFilename:filename data:data shouldGenerateThumbnail:(BOOL)shouldGenerateThumbnail];
}

#pragma mark - Saving data

- (NSString *)pathForFile {
    NSString *savedRequestsPath = [DBNetworkToolkit sharedInstance].savedRequestsPath;
    return [savedRequestsPath stringByAppendingPathComponent:self.filename];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFitSize:(CGSize)maxSize {
    CGFloat scale = MAX(image.size.width / maxSize.width, image.size.height / maxSize.height);
    CGSize newSize = CGSizeMake(image.size.width / scale, image.size.height / scale);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)determineDataTypeWithData:(NSData *)data shouldGenerateThumbnail:(BOOL)shouldGenerateThumbnail completion:(void(^)(void))completion {
    __weak DBRequestDataHandler *weakSelf = self;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        DBRequestDataHandler *strongSelf = weakSelf;
        UIImage *image = [UIImage imageWithData:data];
        NSError *error;
        if (image) {
            strongSelf.dataType = DBRequestModelBodyTypeImage;
            if (shouldGenerateThumbnail) {
                strongSelf.thumbnail = [strongSelf imageWithImage:image scaledToFitSize:DBRequestDataHandlerThumbnailSize];
            }
        } else if ([NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error] != nil) {
            strongSelf.dataType = DBRequestModelBodyTypeJSON;
        } else {
            strongSelf.dataType = DBRequestModelBodyTypeOther;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completion) {
                completion();
            }
        });
    });
}

- (void)saveData:(NSData *)data atFilePath:(NSString *)filePath {
    [[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
    [data writeToFile:filePath atomically:YES];
}

- (void)saveData:(NSData *)data withCompletion:(void(^)(void))completion {
    NSString *filePath = [self pathForFile];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        [self saveData:data atFilePath:filePath];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (completion) {
                completion();
            }
        });
    });
}

- (void)saveData:(NSData *)data shouldGenerateThumbnail:(BOOL)shouldGenerateThumbnail {
    self.dataLength = data.length;
    self.synchronizationStatus = DBRequestModelBodySynchronizationStatusStarted;
    if (self.dataLength > 0) {
        __weak DBRequestDataHandler *weakSelf = self;
        [self determineDataTypeWithData:data shouldGenerateThumbnail:(BOOL)shouldGenerateThumbnail completion:^{
            [self saveData:data withCompletion:^{
                DBRequestDataHandler *strongSelf = weakSelf;
                strongSelf.synchronizationStatus = DBRequestModelBodySynchronizationStatusFinished;
                [strongSelf.delegate requestDataHandlerDidFinishSynchronization:self];
                if (strongSelf.readingCompletion) {
                    strongSelf.readingCompletion(data);
                    strongSelf.readingCompletion = nil;
                }
            }];
        }];
    } else {
        self.dataType = DBRequestModelBodyTypeOther;
        self.synchronizationStatus = DBRequestModelBodySynchronizationStatusFinished;
        [self.delegate requestDataHandlerDidFinishSynchronization:self];
        if (self.readingCompletion) {
            self.readingCompletion(nil);
            self.readingCompletion = nil;
        }
    }
}

#pragma mark - Reading data

- (void)readWithCompletion:(void(^)(NSData *))completion {
    if (self.synchronizationStatus != DBRequestModelBodySynchronizationStatusFinished) {
        self.readingCompletion = completion;
    } else {
        NSString *filePath = [self pathForFile];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (completion) {
                    completion(data);
                }
            });
        });
    }
}

@end
