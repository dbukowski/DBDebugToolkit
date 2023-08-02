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

#import "DBCoreDataFilter.h"

@interface DBCoreDataFilter ()

@property (nonatomic, strong) NSArray <DBCoreDataFilterOperator *> *availableOperators;

@end

@implementation DBCoreDataFilter

#pragma mark - Operators

- (void)setAttribute:(NSAttributeDescription *)attribute {
    if (self.attribute != attribute) {
        BOOL didChangeAttributeType = self.attribute.attributeType != attribute.attributeType;
        _attribute = attribute;
        if (didChangeAttributeType) {
            [self setupAvailableOperators];
        }
    }
}

- (void)setupAvailableOperators {
    self.availableOperators = [self availableOperatorsWithAttributeType:self.attribute.attributeType];
    self.filterOperator = self.availableOperators.firstObject;
    if (self.attribute.attributeType == NSBooleanAttributeType) {
        self.value = [@YES stringValue];
    } else {
        self.value = nil;
    }
}

- (NSArray <DBCoreDataFilterOperator *> *)availableOperatorsWithAttributeType:(NSAttributeType)attributeType {
    switch (attributeType) {
        case NSStringAttributeType:
            return [self availableOperatorsWithStringType];
        case NSBooleanAttributeType:
            return [self availableOperatorsWithBoolType];
        case NSFloatAttributeType:
        case NSDecimalAttributeType:
        case NSDoubleAttributeType:
        case NSInteger16AttributeType:
        case NSInteger32AttributeType:
        case NSInteger64AttributeType:
            return [self availableOperatorsWithNumberType];
        default:
            return nil;
    }
}

- (NSArray <DBCoreDataFilterOperator *> *)availableOperatorsWithStringType {
    return @[ [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"begins with" predicateString:@"BEGINSWITH[cd]"],
              [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"contains" predicateString:@"CONTAINS[cd]"],
              [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"ends with" predicateString:@"ENDSWITH[cd]"] ];
}

- (NSArray <DBCoreDataFilterOperator *> *)availableOperatorsWithNumberType {
    return @[ [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"equal to" predicateString:@"=="],
              [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"greater than or equal to" predicateString:@">="],
              [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"less than or equal to" predicateString:@"<="],
              [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"greater than" predicateString:@">"],
              [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"less than" predicateString:@"<"],
              [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"not equal to" predicateString:@"!="] ];
}

- (NSArray <DBCoreDataFilterOperator *> *)availableOperatorsWithBoolType {
    return @[ [DBCoreDataFilterOperator filterOperatorWithDisplayName:@"equal to" predicateString:@"=="] ];
}

#pragma mark - Predicate

- (NSPredicate *)predicate {
    NSString *valueFormat = self.attribute.attributeType == NSStringAttributeType ? @"\"%@\"" : @"%@";
    NSString *predicateString = [NSString stringWithFormat:@"%@ %@ %@", self.attribute.name,
                                                                        self.filterOperator.predicateString,
                                                                        [NSString stringWithFormat:valueFormat, self.value]];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (NSString *)displayName {
    return [NSString stringWithFormat:@"%@ %@ %@", self.attribute.name,
                                                   self.filterOperator.displayName,
                                                   self.value];
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    DBCoreDataFilter *copy = [[DBCoreDataFilter alloc] init];
    copy.attribute = self.attribute;
    copy.filterOperator = self.filterOperator;
    copy.value = self.value;
    return copy;
}

@end
