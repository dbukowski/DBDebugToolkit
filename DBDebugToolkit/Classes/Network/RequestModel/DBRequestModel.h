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

#import <Foundation/Foundation.h>
#import "DBRequestOutcome.h"

typedef NS_ENUM(NSUInteger, DBRequestModelBodyType) {
    DBRequestModelBodyTypeJSON,
    DBRequestModelBodyTypeImage,
    DBRequestModelBodyTypeOther
};

typedef NS_ENUM(NSUInteger, DBRequestModelBodySynchronizationStatus) {
    DBRequestModelBodySynchronizationStatusNotStarted,
    DBRequestModelBodySynchronizationStatusStarted,
    DBRequestModelBodySynchronizationStatusFinished
};

@class DBRequestModel;

@protocol DBRequestModelDelegate <NSObject>

- (void)requestModelDidFinishSynchronization:(DBRequestModel *)requestModel;

@end

@interface DBRequestModel : NSObject

+ (instancetype)requestModelWithRequest:(NSURLRequest *)request;

- (void)saveOutcome:(DBRequestOutcome *)requestOutcome;

@property (nonatomic, weak) id <DBRequestModelDelegate> delegate;

///-------------------------
/// @name Request properties
///-------------------------

@property (nonatomic, readonly) NSURL *url;

@property (nonatomic, readonly) NSURLRequestCachePolicy cachePolicy;

@property (nonatomic, readonly) NSTimeInterval timeoutInterval;

@property (nonatomic, readonly) NSDate *sendingDate;

@property (nonatomic, readonly) NSString *httpMethod;

@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *allRequestHTTPHeaderFields;

@property (nonatomic, readonly) NSInteger requestBodyLength;

@property (nonatomic, readonly) DBRequestModelBodyType requestBodyType;

@property (nonatomic, readonly) DBRequestModelBodySynchronizationStatus requestBodySynchronizationStatus;

- (void)readRequestBodyWithCompletion:(void(^)(NSData *))completion;

///--------------------------
/// @name Response properties
///--------------------------

@property (nonatomic, readonly) BOOL finished;

@property (nonatomic, readonly) NSString *MIMEType;

@property (nonatomic, readonly) NSString *textEncodingName;

@property (nonatomic, readonly) NSDate *receivingDate;

@property (nonatomic, readonly) NSTimeInterval duration;

@property (nonatomic, readonly) NSNumber *statusCode;

@property (nonatomic, readonly) NSString *localizedStatusCodeString;

@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *allResponseHTTPHeaderFields;

@property (nonatomic, readonly) NSInteger responseBodyLength;

@property (nonatomic, readonly) DBRequestModelBodyType responseBodyType;

@property (nonatomic, readonly) DBRequestModelBodySynchronizationStatus responseBodySynchronizationStatus;

- (void)readResponseBodyWithCompletion:(void(^)(NSData *))completion;

@property (nonatomic, readonly) UIImage *thumbnail;

///-----------------------
/// @name Error properties
///-----------------------

@property (nonatomic, readonly) BOOL didFinishWithError;

@property (nonatomic, readonly) NSInteger errorCode;

@property (nonatomic, readonly) NSString *localizedErrorDescription;

@end
