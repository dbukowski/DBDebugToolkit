//
//  DBCoreDataFilter.m
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

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
