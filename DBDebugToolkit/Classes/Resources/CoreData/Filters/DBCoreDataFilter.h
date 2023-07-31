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
#import "DBCoreDataFilterOperator.h"

/**
 `DBCoreDataFilter` is an object encapsulating the information about one of the filters set up in the `DBCoreDataFilterSettingsTableViewController` instance. Conforms to the `NSCopying` protocol.
 */
@interface DBCoreDataFilter : NSObject <NSCopying>

/**
 The attribute used for filtering.
 */
@property (nonatomic, strong) NSAttributeDescription *attribute;

/**
 The operator used for comparing the attribute with the value, e.g. "contains".
 */
@property (nonatomic, strong) DBCoreDataFilterOperator *filterOperator;

/**
 An array of all the available operator based on the attribute type.
 */
@property (nonatomic, readonly) NSArray <DBCoreDataFilterOperator *> *availableOperators;

/**
 The value used for filtering.
 */
@property (nonatomic, strong) NSString *value;

/**
 Returns the `NSPredicate` instance representing the filter.
 */
- (NSPredicate *)predicate;

/**
 Returns a `NSString` instance that will be presented to the user.
 */
- (NSString *)displayName;

@end
