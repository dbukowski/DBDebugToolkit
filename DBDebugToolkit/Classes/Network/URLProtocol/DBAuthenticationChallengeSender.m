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


#import "DBAuthenticationChallengeSender.h"

@interface DBAuthenticationChallengeSender()

@property (nonatomic, copy) SessionCompletionHandler sessionCompletionHandler;

@end

@implementation DBAuthenticationChallengeSender

#pragma mark - Initialization

- (instancetype)initWithSessionCompletionHandler:(SessionCompletionHandler)sessionCompletionHandler {
    self = [super init];
    if (self) {
        self.sessionCompletionHandler = sessionCompletionHandler;
    }

    return self;
}

+ (instancetype)authenticationChallengeSenderWithSessionCompletionHandler:(SessionCompletionHandler)sessionCompletionHandler {
    return [[self alloc] initWithSessionCompletionHandler:sessionCompletionHandler];
}

#pragma mark - NSURLAuthenticationChallengeSender

- (void)useCredential:(NSURLCredential *)credential forAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (self.sessionCompletionHandler) {
        self.sessionCompletionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

- (void)continueWithoutCredentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (self.sessionCompletionHandler) {
        self.sessionCompletionHandler(NSURLSessionAuthChallengeUseCredential, nil);
    }
}

- (void)cancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge; {
    if (self.sessionCompletionHandler) {
        self.sessionCompletionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

- (void)performDefaultHandlingForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (self.sessionCompletionHandler) {
        self.sessionCompletionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

- (void)rejectProtectionSpaceAndContinueWithChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (self.sessionCompletionHandler) {
        self.sessionCompletionHandler(NSURLSessionAuthChallengeRejectProtectionSpace, nil);
    }
}

@end
