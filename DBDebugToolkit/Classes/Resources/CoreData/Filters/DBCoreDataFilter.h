//
//  DBCoreDataFilter.h
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBCoreDataFilterOperator.h"

@interface DBCoreDataFilter : NSObject <NSCopying>

@property (nonatomic, strong) NSAttributeDescription *attribute;

@property (nonatomic, strong) DBCoreDataFilterOperator *filterOperator;

@property (nonatomic, readonly) NSArray <DBCoreDataFilterOperator *> *availableOperators;

@property (nonatomic, strong) NSString *value;

- (NSPredicate *)predicate;

- (NSString *)displayName;

@end
