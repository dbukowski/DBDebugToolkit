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

#import "DBMainQueueOperation.h"

typedef NS_ENUM(NSUInteger, DBMainQueueOperationState) {
    DBMainQueueOperationStateNotStarted,
    DBMainQueueOperationStateStarted,
    DBMainQueueOperationStateFinished
};

@interface DBMainQueueOperation ()

@property (nonatomic, assign) DBMainQueueOperationState state;
@property (nonatomic, copy) DBMainQueueOperationBlock block;

@end

@implementation DBMainQueueOperation

#pragma mark - Initialization

- (instancetype)initWithMainQueueOperationBlock:(DBMainQueueOperationBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
        self.state = DBMainQueueOperationStateNotStarted;
    }

    return self;
}

+ (instancetype)mainQueueOperationWithBlock:(DBMainQueueOperationBlock)block {
    return [[self alloc] initWithMainQueueOperationBlock:block];
}

#pragma mark - NSOperation methods

- (void)start {
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        self.state = DBMainQueueOperationStateFinished;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self willChangeValueForKey:@"isExecuting"];
        self.state = DBMainQueueOperationStateStarted;
        [self didChangeValueForKey:@"isExecuting"];

        if (self.block) {
            self.block();
        }

        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];

        self.state = DBMainQueueOperationStateFinished;

        [self didChangeValueForKey:@"isFinished"];
        [self didChangeValueForKey:@"isExecuting"];
    });
}

- (BOOL)isFinished {
    return self.state == DBMainQueueOperationStateFinished;
}

- (BOOL)isExecuting {
    return self.state == DBMainQueueOperationStateStarted;
}

- (BOOL)isAsynchronous {
    return NO;
}

@end
