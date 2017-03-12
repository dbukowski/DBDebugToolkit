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

#import "DBCustomVariable.h"

@interface DBCustomVariable ()

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray <NSInvocation *> *actions;

@end

@implementation DBCustomVariable

#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)name value:(id)value {
    self = [super init];
    if (self) {
        _name = name;
        _value = value;
        _actions = [NSMutableArray array];
    }
    
    return self;
}

+ (instancetype)customVariableWithName:(NSString *)name value:(id)value {
    return [[self alloc] initWithName:name value:value];
}

#pragma mark - Setting value

- (void)setValue:(id)value {
    _value = value;
    for (NSInvocation *action in self.actions) {
        if (action.methodSignature.numberOfArguments > 2) {
            [action setArgument:(void *)&self atIndex:2];
        }
        [action invoke];
    }
}

#pragma mark - Variable type

- (DBCustomVariableType)type {
    if ([self.value isKindOfClass:[NSString class]]) {
        return DBCustomVariableTypeString;
    } else if ([self.value isKindOfClass:[NSNumber class]]) {
        NSNumber *numberValue = (NSNumber *)self.value;
        CFNumberType numberType = CFNumberGetType((CFNumberRef)numberValue);
        switch (numberType) {
            case kCFNumberCharType:
                return DBCustomVariableTypeBool;
            case kCFNumberSInt8Type:
            case kCFNumberSInt16Type:
            case kCFNumberSInt32Type:
            case kCFNumberSInt64Type:
            case kCFNumberShortType:
            case kCFNumberIntType:
            case kCFNumberLongType:
            case kCFNumberLongLongType:
            case kCFNumberCFIndexType:
            case kCFNumberNSIntegerType:
                return DBCustomVariableTypeInt;
            case kCFNumberFloat32Type:
            case kCFNumberFloat64Type:
            case kCFNumberFloatType:
            case kCFNumberDoubleType:
            case kCFNumberCGFloatType:
                return DBCustomVariableTypeDouble;
        }
    }
    return DBCustomVariableTypeUnrecognized;
}

#pragma mark - Actions

- (void)addTarget:(id)target action:(SEL)action {
    NSMethodSignature *methodSignature = [target methodSignatureForSelector:action];
    NSInvocation *newAction = [NSInvocation invocationWithMethodSignature:methodSignature];
    newAction.target = target;
    newAction.selector = action;
    [newAction retainArguments];
    [self.actions addObject:newAction];
}

- (void)removeTarget:(id)target action:(SEL)action {
    if (target == nil) {
        [self.actions removeAllObjects];
    } else {
        NSPredicate *filterPredicate = nil;
        if (action == nil) {
            filterPredicate = [NSPredicate predicateWithFormat:@"target != %@", target];
        } else {
            filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                NSInvocation *invocation = (NSInvocation *)evaluatedObject;
                return invocation.target != target || NSStringFromSelector(invocation.selector) != NSStringFromSelector(action);
            }];
        }
        [self.actions filterUsingPredicate:filterPredicate];
    }
}

@end
