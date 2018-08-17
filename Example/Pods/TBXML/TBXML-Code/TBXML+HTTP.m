//
//  TBXML+HTTP.m
//
//  Created by Tom Bradley on 29/01/2011.
//  Copyright 2012 71Squared All rights reserved.
//

#import "TBXML+HTTP.h"

@implementation NSMutableURLRequest (TBXML_HTTP)


+ (NSMutableURLRequest*) tbxmlGetRequestWithURL:(NSURL*)url {
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"GET"];
    
	return request;
}

+ (NSMutableURLRequest*) tbxmlPostRequestWithURL:(NSURL*)url parameters:(NSDictionary*)parameters {
	
	NSMutableArray * params = [NSMutableArray new];
	
	for (NSString * key in [parameters allKeys]) {
		[params addObject:[NSString stringWithFormat:@"%@=%@", key, [parameters objectForKey:key]]];
	}
	
	NSData * postData = [[params componentsJoinedByString:@"&"] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:postData];

	return request;
}

@end


@implementation NSURLConnection (TBXML_HTTP)

+ (void)tbxmlAsyncRequest:(NSURLRequest *)request success:(TBXMLAsyncRequestSuccessBlock)successBlock failure:(TBXMLAsyncRequestFailureBlock)failureBlock {
    
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
		@autoreleasepool {
			NSURLResponse *response = nil;
			NSError *error = nil;
			NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
			if (error) {
				failureBlock(data,error);
			} else {
				successBlock(data,response);
			}
		}		
	});
}

@end


@implementation TBXML (TBXML_HTTP)

+ (id)tbxmlWithURL:(NSURL*)aURL success:(TBXMLSuccessBlock)successBlock failure:(TBXMLFailureBlock)failureBlock {
	return [[TBXML alloc] initWithURL:aURL success:successBlock failure:failureBlock];
}

- (id)initWithURL:(NSURL*)aURL success:(TBXMLSuccessBlock)successBlock failure:(TBXMLFailureBlock)failureBlock {
	self = [self init];
	if (self != nil) {
        
        TBXMLAsyncRequestSuccessBlock requestSuccessBlock = ^(NSData *data, NSURLResponse *response) {

            NSError *error = nil;
            [self decodeData:data withError:&error];
            
            // If TBXML found a root node, process element and iterate all children
            if (!error) {
                successBlock(self);
            } else {
                failureBlock(self, error);
            }
        };
        
        TBXMLAsyncRequestFailureBlock requestFailureBlock = ^(NSData *data, NSError *error) {
            failureBlock(self, error);
        };
        
        
        [NSURLConnection tbxmlAsyncRequest:[NSMutableURLRequest tbxmlGetRequestWithURL:aURL] 
                                   success:requestSuccessBlock 
                                   failure:requestFailureBlock];
	}
	return self;
}

@end