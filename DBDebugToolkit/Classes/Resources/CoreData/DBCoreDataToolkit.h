//
//  DBCoreDataToolkit.h
//  Pods
//
//  Created by Dariusz Bukowski on 26.02.2017.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DBCoreDataToolkit : NSObject

+ (instancetype)sharedInstance;

- (void)addPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@property (nonatomic, readonly) NSArray <NSPersistentStoreCoordinator *> *persistentStoreCoordinators;

@end
