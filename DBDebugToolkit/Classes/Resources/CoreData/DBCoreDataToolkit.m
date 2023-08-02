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

#import "DBCoreDataToolkit.h"

@interface DBCoreDataToolkit ()

@property (nonatomic, strong) NSArray <NSPersistentStoreCoordinator *> *persistentStoreCoordinators;

@end

@implementation DBCoreDataToolkit

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _persistentStoreCoordinators = [NSArray array];
    }
    
    return self;
}

+ (instancetype)sharedInstance {
    static DBCoreDataToolkit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBCoreDataToolkit alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Persistent store coordinators

- (void)addPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSMutableArray *persistentStoreCoordinators = [self.persistentStoreCoordinators mutableCopy];
    [persistentStoreCoordinators addObject:persistentStoreCoordinator];
    self.persistentStoreCoordinators = [persistentStoreCoordinators copy];
}

@end
