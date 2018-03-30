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

typedef void(^DBMainQueueOperationBlock)(void);

/**
 `DBMainQueueOperation` is a `NSOperation` subclass running a given block on a main queue.
 */
@interface DBMainQueueOperation : NSOperation

/**
 Initializes `DBMainQueueOperation` object with a block.

 @param block The block that will be invoked on the main queue.
 */
- (instancetype)initWithMainQueueOperationBlock:(DBMainQueueOperationBlock)block;

/**
 Creates and returns a new `DBMainQueueOperation` instance encapsulating a given block.

 @param block The block that will be invoked on the main queue.
 */
+ (instancetype)mainQueueOperationWithBlock:(DBMainQueueOperationBlock)block;

@end
