//
//  DBCoreDataFilterOperator.m
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

#import "DBCoreDataFilterOperator.h"

@interface DBCoreDataFilterOperator ()

@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *predicateString;

@end

@implementation DBCoreDataFilterOperator

#pragma mark - Initialization

+ (instancetype)filterOperatorWithDisplayName:(NSString *)displayName predicateString:(NSString *)predicateString {
    DBCoreDataFilterOperator *filterOperator = [DBCoreDataFilterOperator new];
    filterOperator.displayName = displayName;
    filterOperator.predicateString = predicateString;
    return filterOperator;
}

@end
