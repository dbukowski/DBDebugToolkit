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

@class DBNetworkToolkit;

/**
 A protocol used for informing about changes in logging settings or in logged requests list.
 */
@protocol DBNetworkToolkitDelegate <NSObject>

/**
 Informs the delegate that the logged requests list has changed.
 
 @param networkToolkit The `DBNetworkToolkit` instance that changed the logged requests list.
 */
- (void)networkDebugToolkitDidUpdateRequestsList:(DBNetworkToolkit *)networkToolkit;

/**
 Informs the delegate that the object at the given index on the logged requests list has changed.
 
 @param networkToolkit The `DBNetworkToolkit` instance that changed the logged request.
 @param index The index of the logged request that has changed.
 */
- (void)networkDebugToolkit:(DBNetworkToolkit *)networkToolkit didUpdateRequestAtIndex:(NSInteger)index;

/**
 Informs the delegate that the logging setting have changed.
 
 @param networkToolkit The `DBNetworkToolkit` instance that changed the logging settings.
 @param enabled The new value of the flag determining whether the requests logging is enabled or not.
 */
- (void)networkDebugToolkit:(DBNetworkToolkit *)networkToolkit didSetEnabled:(BOOL)enabled;

@end

/**
 Current registered NSURLProtocol a protocol class.
 */
extern Class DBNetworkURLProtocolClass;

/**
 `DBNetworkToolkit` is a class responsible for logging all the requests sent by the application.
 */
@interface DBNetworkToolkit : NSObject

/**
 Returns the singleton instance.
 */
+ (instancetype)sharedInstance;

/**
 This method registers NSURLProtocol a protocol class.
 */
+ (void)registerURLProtocolClass:(Class)protocolClass;

/**
 Returns a string containing the path to the directory where the requests data is stored.
 */
- (NSString *)savedRequestsPath;

/**
 Saves the given request.
 
 @param request The request that should be saved by `DBNetworkToolkit` instance.
 */
- (void)saveRequest:(NSURLRequest *)request;

/**
 Saves the response for a given request.
 
 @param requestOutcome The `DBRequestOutcome` instance containing all the information about the request outcome.
 @param request The request that finished with the given outcome.
 */
- (void)saveRequestOutcome:(DBRequestOutcome *)requestOutcome forRequest:(NSURLRequest *)request;

/**
 Boolean variable determining whether the requests logging is enabled or not. It is true by default.
 */
@property (nonatomic, assign) BOOL loggingEnabled;

/**
 Delegate that will be informed about changes in the logged requests list or in the enabled flag value. It needs to conform to `DBNetworkToolkitDelegate` protocol.
 */
@property (nonatomic, weak) id <DBNetworkToolkitDelegate> delegate;

/**
 An array containing all the logged requests.
 */
@property (nonatomic, readonly) NSArray *savedRequests;

@end
