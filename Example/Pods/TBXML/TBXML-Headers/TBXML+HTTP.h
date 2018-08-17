//
//  TBXML+HTTP.h
//
//  Created by Tom Bradley on 29/01/2011.
//  Copyright 2012 71Squared All rights reserved.
//

#import "TBXML.h"

typedef void (^TBXMLAsyncRequestSuccessBlock)(NSData *,NSURLResponse *);
typedef void (^TBXMLAsyncRequestFailureBlock)(NSData *,NSError *);

@interface NSMutableURLRequest (TBXML_HTTP)

+ (NSMutableURLRequest*) tbxmlGetRequestWithURL:(NSURL*)url;
+ (NSMutableURLRequest*) tbxmlPostRequestWithURL:(NSURL*)url parameters:(NSDictionary*)parameters;

@end


@interface NSURLConnection (TBXML_HTTP)

+ (void)tbxmlAsyncRequest:(NSURLRequest *)request success:(TBXMLAsyncRequestSuccessBlock)successBlock failure:(TBXMLAsyncRequestFailureBlock)failureBlock;

@end


@interface TBXML (TBXML_HTTP)

+ (id)tbxmlWithURL:(NSURL*)aURL success:(TBXMLSuccessBlock)successBlock failure:(TBXMLFailureBlock)failureBlock;
- (id)initWithURL:(NSURL*)aURL success:(TBXMLSuccessBlock)successBlock failure:(TBXMLFailureBlock)failureBlock;

@end


