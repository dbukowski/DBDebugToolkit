//
//  NSPersistentStoreCoordinator+DBCoreDataToolkit.m
//  Pods
//
//  Created by Dariusz Bukowski on 26.02.2017.
//
//

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
