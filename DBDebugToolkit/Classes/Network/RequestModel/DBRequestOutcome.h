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

/**
 `DBRequestOutcome` is a class wrapping all the information about the request result.
 */
@interface DBRequestOutcome : NSObject

/**
 Creates and returns a new instance wrapping the information about a request that received a proper response.
 
 @param response The received response.
 @param data The data received with the response.
 */
+ (instancetype)outcomeWithResponse:(NSURLResponse *)response data:(NSData *)data;

/**
 Creates and returns a new instance wrapping the information about a request that failed on the client side.
 
 @param error The client side error.
 */
+ (instancetype)outcomeWithError:(NSError *)error;

/**
 `NSURLResponse` instance that was received. Read-only.
 */
@property (nonatomic, readonly) NSURLResponse *response;

/**
 `NSData` instance that was received. Read-only.
 */
@property (nonatomic, readonly) NSData *data;

/**
 `NSError` instance that was received. Read-only.
 */
@property (nonatomic, readonly) NSError *error;

@end
