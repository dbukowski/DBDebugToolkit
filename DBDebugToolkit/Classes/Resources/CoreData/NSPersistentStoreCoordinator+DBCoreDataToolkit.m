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

#import "NSPersistentStoreCoordinator+DBCoreDataToolkit.h"
#import "NSObject+DBDebugToolkit.h"
#import "DBCoreDataToolkit.h"

@implementation NSPersistentStoreCoordinator (DBCoreDataToolkit)

#pragma mark - Method swizzling

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self exchangeInstanceMethodsWithOriginalSelector:@selector(initWithManagedObjectModel:)
                                      andSwizzledSelector:@selector(db_initWithManagedObjectModel:)];
    });
}

#pragma mark - Registering persistent store coordinator

- (instancetype)db_initWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel {
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self db_initWithManagedObjectModel:managedObjectModel];
    [persistentStoreCoordinator addToCoreDataToolkit];
    return persistentStoreCoordinator;
}

- (void)addToCoreDataToolkit {
    DBCoreDataToolkit *coreDataToolkit = [DBCoreDataToolkit sharedInstance];
    [coreDataToolkit addPersistentStoreCoordinator:self];
}

@end
