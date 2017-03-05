//
//  DBCoreDataFilterSettings.h
//  Pods
//
//  Created by Dariusz Bukowski on 04.03.2017.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DBCoreDataFilter.h"

@interface DBCoreDataFilterSettings : NSObject

+ (instancetype)defaultFilterSettingsForEntity:(NSEntityDescription *)entity;

@property (nonatomic, strong) NSAttributeDescription *sortDescriptorAttribute;

@property (nonatomic, assign) BOOL isSortingAscending;

@property (nonatomic, strong) NSArray <DBCoreDataFilter *> *filters;

@property (nonatomic, readonly) NSArray <NSAttributeDescription *> *attributesForSorting;

@property (nonatomic, readonly) NSArray <NSAttributeDescription *> *attributesForFiltering;

- (NSSortDescriptor *)sortDescriptor;

- (NSPredicate *)predicate;

- (DBCoreDataFilter *)defaultNewFilter;

- (void)removeFilterAtIndex:(NSInteger)index;

- (void)addFilter:(DBCoreDataFilter *)filter;

- (void)saveFilter:(DBCoreDataFilter *)filter atIndex:(NSInteger)index;

@end
