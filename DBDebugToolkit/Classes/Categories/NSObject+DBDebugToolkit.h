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
 `NSObject` category adding helper methods for swizzling.
 */
@interface NSObject (DBDebugToolkit)

/**
 Exchanges class methods between two selectors using method swizzling.
 
 @param originalSelector The original selector, which is supposed to have its implementation replaced.
 @param swizzledSelector The swizzled selector, providing the new implementation.
 */
+ (void)exchangeClassMethodsWithOriginalSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector;

/**
 Exchanges instance methods between two selectors using method swizzling.
 
 @param originalSelector The original selector, which is supposed to have its implementation replaced.
 @param swizzledSelector The swizzled selector, providing the new implementation.
 */
+ (void)exchangeInstanceMethodsWithOriginalSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector;

/**
 Replaces instance method implementation with a block.
 
 @param originalSelector The original selector, which is supposed to have its implementation replaced.
 @param block The block containing new implementation.
 */
+ (IMP)replaceMethodWithSelector:(SEL)originalSelector block:(id)block;

@end
