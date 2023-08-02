//
//  DBAppDelegate.m
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 11/19/2016.
//  Copyright (c) 2016 Dariusz Bukowski. All rights reserved.
//

#import "DBAppDelegate.h"
#import <CoreData/CoreData.h>
#import <DBDebugToolkit/DBDebugToolkit.h>
#import <DBDebugToolkit/DBShakeTrigger.h>
#import <DBDebugToolkit/DBTapTrigger.h>
#import <DBDebugToolkit/DBLongPressTrigger.h>
#import "DBCoreDataRandomDataGenerator.h"

@interface DBAppDelegate ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation DBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DBDebugToolkit setupWithTriggers: @[ [DBShakeTrigger trigger], [DBTapTrigger trigger], [DBLongPressTrigger trigger]]];
    [self setupUserDefaultsExample];
    [self setupKeychainExample];
    [self setupCoreData];
    [self setupExampleShortcutItems];
    DBCustomAction *prepopulateCoreDataAction = [DBCustomAction customActionWithName:@"Add more core data instances"
                                                                                body:^{
                                                                                    [self prepopulateCoreData];
                                                                                }];
    [DBDebugToolkit addCustomAction:prepopulateCoreDataAction];
    [DBDebugToolkit setupCrashReporting];
    [DBDebugToolkit addClearDataShortcutItem];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Resource examples

- (void)setupUserDefaultsExample {
    for (NSInteger i = 1; i <= 5; i++) {
        NSString *value = [NSString stringWithFormat:@"Example user defaults object %ld", (long)i];
        NSString *key = [NSString stringWithFormat:@"Example user defaults key %ld", (long)i];
        [self addValue:value forKeyInUserDefaults:key];
    }
}

- (void)addValue:(NSString *)value forKeyInUserDefaults:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setupKeychainExample {
    for (NSInteger i = 1; i <= 5; i++) {
        NSString *value = [NSString stringWithFormat:@"Example keychain object %ld", (long)i];
        NSString *key = [NSString stringWithFormat:@"Example keychain key %ld", (long)i];
        [self addValue:value forKeyInKeychain:key];
    }
}

- (void)setupExampleShortcutItems {
    if (![[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9, 0, 0}]) {
        // Shortcut items are not supported on the running iOS version.
        return;
    }

    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"Type1" localizedTitle:@"Example shortcut 1"];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:@"Type2" localizedTitle:@"Example shortcut 2"];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc] initWithType:@"Type3" localizedTitle:@"Example shortcut 3"];
    UIApplication.sharedApplication.shortcutItems = @[item1, item2, item3];
}

- (void)addValue:(NSString *)value forKeyInKeychain:(NSString *)key {
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)kSecClassGenericPassword, (__bridge id)kSecClass,
                                  key, (__bridge id)kSecAttrAccount,
                                  data, (__bridge id)kSecValueData,
                                  nil];
    SecItemDelete((__bridge CFDictionaryRef)query);
    SecItemAdd((__bridge CFDictionaryRef)query, nil);
}


#pragma mark - Core Data stack

- (void)setupCoreData {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
    BOOL shouldPrepopulateData = ![fileManager fileExistsAtPath:storeURL.path];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSError *error = nil;
        NSPersistentStoreCoordinator *psc = [moc persistentStoreCoordinator];
        NSDictionary *options = [NSDictionary dictionaryWithObjects:@[@YES, @YES]
                                                            forKeys:@[NSMigratePersistentStoresAutomaticallyOption, NSInferMappingModelAutomaticallyOption]];
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
        self.managedObjectContext = moc;
        if (shouldPrepopulateData) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self prepopulateCoreData];
            });
        }
    });
}

- (void)prepopulateCoreData {
    // Adds 100 new random people to the database with their addresses, cars and passports.
    [DBCoreDataRandomDataGenerator addNewRandomDataWithManagedObjectContext:self.managedObjectContext peopleCount:100];
}

@end
