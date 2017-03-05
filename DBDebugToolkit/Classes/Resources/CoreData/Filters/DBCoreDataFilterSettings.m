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

#import "DBCoreDataFilterSettings.h"

@interface DBCoreDataFilterSettings ()

@property (nonatomic, strong) NSArray <NSAttributeDescription *> *attributesForSorting;
@property (nonatomic, strong) NSArray <NSAttributeDescription *> *attributesForFiltering;

@end

@implementation DBCoreDataFilterSettings

#pragma mark - Initialization

+ (instancetype)defaultFilterSettingsForEntity:(NSEntityDescription *)entity {
    DBCoreDataFilterSettings *filterSettings = [DBCoreDataFilterSettings new];
    [filterSettings setupAttributesWithEntity:entity];
    filterSettings.isSortingAscending = YES;
    filterSettings.filters = [NSArray array];
    filterSettings.sortDescriptorAttribute = filterSettings.attributesForSorting.firstObject;
    return filterSettings;
}

- (void)setupAttributesWithEntity:(NSEntityDescription *)entity {
    NSArray *allAttributes = entity.attributesByName.allValues;
    NSMutableArray *attributesForSorting = [NSMutableArray array];
    NSMutableArray *attributesForFiltering = [NSMutableArray array];
    for (NSAttributeDescription *attribute in allAttributes) {
        switch (attribute.attributeType) {
            case NSStringAttributeType:
            case NSFloatAttributeType:
            case NSDoubleAttributeType:
            case NSBooleanAttributeType:
            case NSDecimalAttributeType:
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
                [attributesForFiltering addObject:attribute];
            case NSDateAttributeType:
                [attributesForSorting addObject:attribute];
            default:
                break;
        }
    }
    self.attributesForSorting = [attributesForSorting copy];
    self.attributesForFiltering = [attributesForFiltering copy];
}

#pragma mark - Sorting

- (NSSortDescriptor *)sortDescriptor {
    if (self.attributesForSorting.count == 0) {
        return nil;
    } else if (self.sortDescriptorAttribute.attributeType == NSStringAttributeType) {
        return [NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorAttribute.name
                                             ascending:self.isSortingAscending
                                              selector:@selector(localizedCaseInsensitiveCompare:)];
    } else {
        return [NSSortDescriptor sortDescriptorWithKey:self.sortDescriptorAttribute.name
                                             ascending:self.isSortingAscending];
    }
}

#pragma mark - Filtering

- (NSPredicate *)predicate {
    NSMutableArray *predicates = [NSMutableArray array];
    for (DBCoreDataFilter *filter in self.filters) {
        [predicates addObject:filter.predicate];
    }
    NSString *predicateString = [predicates componentsJoinedByString:@" AND "];
    return predicates.count == 0 ? nil : [NSPredicate predicateWithFormat:predicateString];
}

- (DBCoreDataFilter *)defaultNewFilter {
    DBCoreDataFilter *filter = [DBCoreDataFilter new];
    filter.attribute = self.attributesForFiltering.firstObject;
    return filter;
}

- (void)removeFilterAtIndex:(NSInteger)index {
    NSMutableArray *filters = [NSMutableArray arrayWithArray:self.filters];
    [filters removeObjectAtIndex:index];
    self.filters = [filters copy];
}

- (void)addFilter:(DBCoreDataFilter *)filter {
    NSMutableArray *filters = [NSMutableArray arrayWithArray:self.filters];
    [filters addObject:filter];
    self.filters = [filters copy];
}

- (void)saveFilter:(DBCoreDataFilter *)filter atIndex:(NSInteger)index {
    NSMutableArray *filters = [NSMutableArray arrayWithArray:self.filters];
    filters[index] = filter;
    self.filters = [filters copy];
}

@end
