//
//  DBCoreDataToolkit.m
//  Pods
//
//  Created by Dariusz Bukowski on 26.02.2017.
//
//

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
