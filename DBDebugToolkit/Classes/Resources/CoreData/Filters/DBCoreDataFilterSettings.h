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
#import <CoreData/CoreData.h>
#import "DBCoreDataFilter.h"

/**
 `DBCoreDataFilterSettings` is an object encapsulating the information about all the filters and sorting settings set up in `DBCoreDataFilterSettingsTableViewController` instance.
 */
@interface DBCoreDataFilterSettings : NSObject

/**
 Creates and returns a default instance for the given entity. The default instance has an empty filters list and one of the attributes preselected for sorting.
 
 @param entity The entity that will be filtered with the new instance.
 */
+ (instancetype)defaultFilterSettingsForEntity:(NSEntityDescription *)entity;

/**
 The `NSAttributeDescription` instance used for sorting.
 */
@property (nonatomic, strong) NSAttributeDescription *sortDescriptorAttribute;

/**
 A boolean flag determining whether the objects should be sorted ascending or descending by the selected attribute.
 */
@property (nonatomic, assign) BOOL isSortingAscending;

/**
 An array of all the filters set up in the settings.
 */
@property (nonatomic, strong) NSArray <DBCoreDataFilter *> *filters;

/**
 An array of all the attributes that can be used for sorting the objects.
 */
@property (nonatomic, readonly) NSArray <NSAttributeDescription *> *attributesForSorting;

/**
 An array of all the attributes that can be used for filtering the objects.
 */
@property (nonatomic, readonly) NSArray <NSAttributeDescription *> *attributesForFiltering;

/**
 Returns the `NSSortDescriptor` instance based on `sortDescriptorAttribute` and `isSortingAscending` properties.
 */
- (NSSortDescriptor *)sortDescriptor;

/**
 Returns the `NSPredicate` instance based on all the `DBCoreDataFilter` instances stored in the `filters` property.
 */
- (NSPredicate *)predicate;

/**
 Creates and returns a new instance of `DBCoreDataFilter` that can be used for filtering of the given entity.
 */
- (DBCoreDataFilter *)defaultNewFilter;

/**
 Removes filter at the given index.
 
 @param index The index of the filter that needs to be removed.
 */
- (void)removeFilterAtIndex:(NSInteger)index;

/**
 Adds the given filter to the stored array.
 
 @param filter The `DBCoreDataFilter` instance that will be inserted to the end of the array stored in the `filters` property.
 */
- (void)addFilter:(DBCoreDataFilter *)filter;

/**
 Saves changes in the filter at the given index.
 
 @param filter The `DBCoreDataFilter` instance that will be inserted to the array stored in the `filters` property at the given index.
 @param index Index of the filter that will be replaced by the given filter.
 */
- (void)saveFilter:(DBCoreDataFilter *)filter atIndex:(NSInteger)index;

@end
