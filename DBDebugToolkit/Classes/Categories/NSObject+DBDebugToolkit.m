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

#import "NSObject+DBDebugToolkit.h"
#import <objc/runtime.h>

@implementation NSObject (DBDebugToolkit)

+ (void)exchangeClassMethodsWithOriginalSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector {
    [self exchangeMethodsWithOriginalSelector:originalSelector
                             swizzledSelector:swizzledSelector
                                 classMethods:YES];
}

+ (void)exchangeInstanceMethodsWithOriginalSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector {
    [self exchangeMethodsWithOriginalSelector:originalSelector
                             swizzledSelector:swizzledSelector
                                 classMethods:NO];
}

+ (IMP)replaceMethodWithSelector:(SEL)originalSelector block:(id)block {
    NSCParameterAssert(block);
    
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    NSCParameterAssert(originalMethod);
    
    IMP newIMP = imp_implementationWithBlock(block);
    
    if (!class_addMethod(class, originalSelector, newIMP, method_getTypeEncoding(originalMethod))) {
        return method_setImplementation(originalMethod, newIMP);
    } else {
        return method_getImplementation(originalMethod);
    }
}

#pragma mark - Private

+ (void)exchangeMethodsWithOriginalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector
                               classMethods:(BOOL)classMethods {
    Class class = classMethods ? object_getClass((id)self) : [self class];
    Method originalMethod = classMethods ? class_getClassMethod(class, originalSelector) : class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = classMethods ? class_getClassMethod(class, swizzledSelector) : class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
