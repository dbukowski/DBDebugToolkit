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

#import "DBUserDefaultsToolkit.h"
#import "DBDebugToolkitUserDefaultsKeys.h"

@interface DBUserDefaultsToolkit ()

@property (nonatomic, strong) NSMutableArray *keys;

@end

@implementation DBUserDefaultsToolkit

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
