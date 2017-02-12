//
//  DBUserDefaultsListViewModel.m
//  Pods
//
//  Created by Dariusz Bukowski on 12.02.2017.
//
//

#import "DBUserDefaultsListViewModel.h"
#import "DBDebugToolkitUserDefaultsKeys.h"

@interface DBUserDefaultsListViewModel ()

@property (nonatomic, strong) NSMutableArray *keys;

@end

@implementation DBUserDefaultsListViewModel

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupKeys];
    }
    
    return self;
}

- (void)setupKeys {
    self.keys = [NSMutableArray array];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [self.keys addObjectsFromArray:[[[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain] allKeys]];
    [self.keys removeObject:DBDebugToolkitUserDefaultsSimulatedLocationLatitudeKey];
    [self.keys removeObject:DBDebugToolkitUserDefaultsSimulatedLocationLongitudeKey];
    [self.keys sortUsingSelector:@selector(compare:)];
}

#pragma mark - DBTitleValueListViewModel

- (NSString *)viewTitle {
    return @"User defaults";
}

- (NSInteger)numberOfItems {
    return self.keys.count;
}

- (DBTitleValueTableViewCellDataSource *)dataSourceForItemAtIndex:(NSInteger)index {
    NSString *key = self.keys[index];
    NSString *value = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:key]];
    return [DBTitleValueTableViewCellDataSource dataSourceWithTitle:key
                                                              value:value];
}

- (void)handleClearAction {
    for (NSString *key in self.keys) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.keys removeAllObjects];
}

- (void)handleDeleteItemActionAtIndex:(NSInteger)index {
    NSString *key = self.keys[index];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.keys removeObject:key];
}

- (NSString *)emptyListDescriptionString {
    return @"There are no entries in the user defaults.";
}

@end
