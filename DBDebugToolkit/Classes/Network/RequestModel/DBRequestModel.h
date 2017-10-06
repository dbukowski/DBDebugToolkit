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

/**
 Enum with the data type of the request or response body.
 */
typedef NS_ENUM(NSUInteger, DBRequestModelBodyType) {
    DBRequestModelBodyTypeJSON,
    DBRequestModelBodyTypeImage,
    DBRequestModelBodyTypeOther
};

/**
 Enum with the status of the request or response body data synchronization.
 */
typedef NS_ENUM(NSUInteger, DBRequestModelBodySynchronizationStatus) {
    DBRequestModelBodySynchronizationStatusNotStarted,
    DBRequestModelBodySynchronizationStatusStarted,
    DBRequestModelBodySynchronizationStatusFinished
};

@class DBRequestModel;

/**
 A protocol used for informing about the finishing of the request or response body data synchronization.
 */
@protocol DBRequestModelDelegate <NSObject>

/**
 Informs the delegate that the synchronization of the request or response body data has finished.
 
 @param requestModel The `DBRequestModel` instance that finished the data synchronization.
 */
- (void)requestModelDidFinishSynchronization:(DBRequestModel *)requestModel;

@end

/**
 `DBRequestModel` is an object containing all the information about a request and its outcome.
 */
@interface DBRequestModel : NSObject

/**
 Creates and returns a new instance for the given request.
 
 @param request The `NSURLRequest` instance.
 */
+ (instancetype)requestModelWithRequest:(NSURLRequest *)request;

/**
 Saves the outcome of the request.
 
 @param requestOutcome The `DBRequestOutcome` instance wrapping the response and data or the error received.
 */
- (void)saveOutcome:(DBRequestOutcome *)requestOutcome;

/**
 Saves the body of the request, contained either in an `NSData` instance or in `NSInputStream` instance.
 
 @param body The `NSData` instance containing the body. If empty, the body is contained in the input stream.
 @param bodyStream The `NSInputStream` instance containing the body in case of empty `NSData` instance.
 */
- (void)saveBodyWithData:(NSData *)body inputStream:(NSInputStream *)bodyStream;

/**
 Delegate that will be informed about the finishing of the body data synchronization. It needs to conform to `DBRequestModelDelegate` protocol.
 */
@property (nonatomic, weak) id <DBRequestModelDelegate> delegate;

///-------------------------
/// @name Request properties
///-------------------------

/**
 `NSURL` instance that was used for the request. Read-only.
 */
@property (nonatomic, readonly) NSURL *url;

/**
 Cache policy that was used for the request. Read-only.
 */
@property (nonatomic, readonly) NSURLRequestCachePolicy cachePolicy;

/**
 Timeout interval that was used for the request. Read-only.
 */
@property (nonatomic, readonly) NSTimeInterval timeoutInterval;

/**
 Sending date of the request. Read-only.
 */
@property (nonatomic, readonly) NSDate *sendingDate;

/**
 HTTP method of the request. Is `nil` if the request used a different protocol. Read-only.
 */
@property (nonatomic, readonly) NSString *httpMethod;

/**
 Dictionary containing all the request HTTP hearers. Is `nil` if the request used a different protocol. Read-only.
 */
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *allRequestHTTPHeaderFields;

/**
 The size of request body in bytes. Read-only.
 */
@property (nonatomic, readonly) NSInteger requestBodyLength;

/**
 `DBRequestModelBodyType` value describing the request body data type. Read-only.
 */
@property (nonatomic, readonly) DBRequestModelBodyType requestBodyType;

/**
 `DBRequestModelBodySynchronizationStatus` value describing the request body data synchronization status. Read-only.
 */
@property (nonatomic, readonly) DBRequestModelBodySynchronizationStatus requestBodySynchronizationStatus;

/**
 Reads the saved request body data.
 
 @param completion The block that will be called with the read data.
 */
- (void)readRequestBodyWithCompletion:(void(^)(NSData *))completion;

///--------------------------
/// @name Response properties
///--------------------------

/**
 The boolean flag informing if the request did finish. Read-only.
 */
@property (nonatomic, readonly) BOOL finished;

/**
 The MIME type of the response. Read-only.
 */
@property (nonatomic, readonly) NSString *MIMEType;

/**
 Text encoding name of the response. Read-only.
 */
@property (nonatomic, readonly) NSString *textEncodingName;

/**
 Receiving date of the response. Read-only.
 */
@property (nonatomic, readonly) NSDate *receivingDate;

/**
 Request duration. Read-only.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 HTTP status code of the response. Is `nil` if the request used a different protocol. Read-only.
 */
@property (nonatomic, readonly) NSNumber *statusCode;

/**
 Localized description of the response HTTP status code. Is `nil` if the request used a different protocol. Read-only.
 */
@property (nonatomic, readonly) NSString *localizedStatusCodeString;

/**
 Dictionary containing all the response HTTP hearers. Is `nil` if the request used a different protocol. Read-only.
 */
@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> *allResponseHTTPHeaderFields;

/**
 The size of response body in bytes. Read-only.
 */
@property (nonatomic, readonly) NSInteger responseBodyLength;

/**
 `DBRequestModelBodyType` value describing the response body data type. Read-only.
 */
@property (nonatomic, readonly) DBRequestModelBodyType responseBodyType;

/**
 `DBRequestModelBodySynchronizationStatus` value describing the response body data synchronization status. Read-only.
 */
@property (nonatomic, readonly) DBRequestModelBodySynchronizationStatus responseBodySynchronizationStatus;

/**
 `UIImage` instance containing the thumbnail for the image received in the response data.
 It is `nil` if the data is not yet synchronized or if the data is not describing an image. Read-only.
 */
@property (nonatomic, readonly) UIImage *thumbnail;

/**
 Reads the saved response body data.
 
 @param completion The block that will be called with the read data.
 */
- (void)readResponseBodyWithCompletion:(void(^)(NSData *))completion;

///-----------------------
/// @name Error properties
///-----------------------

/**
 The boolean flag informing if the request did finish with error. Read-only.
 */
@property (nonatomic, readonly) BOOL didFinishWithError;

/**
 The code of the client side error.
 */
@property (nonatomic, readonly) NSInteger errorCode;

/**
 The localized description of the client side error.
 */
@property (nonatomic, readonly) NSString *localizedErrorDescription;

@end
