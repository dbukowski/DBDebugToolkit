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

@import UIKit;
#import "DBEnvironmentToolkit.h"
#import "DBDebugSettings.h"

typedef enum : NSUInteger {
    FIRST_ITEM,
    
    CONTENT_ITEM = FIRST_ITEM,
    DEVEL_ITEM,
    RELEASE_ITEM,
    TEST_ITEM,
    CUSTOM_ITEM,
    
    LAST_ITEM = CUSTOM_ITEM,
    ITEMS_COUNT
} DBEnvironmentItem;


typedef enum : NSUInteger {
    DBEnvironmentFirst,
    DBEnvironmentWork = DBEnvironmentFirst,
    DBEnvironmentContent,
    DBEnvironmentLast = DBEnvironmentContent,
    DBEnvironmentCount
} DBEnvironmentConfig;

NSString * const DBEnvironmentDevelopment = @"devel";
NSString * const DBEnvironmentRelease     = @"release";
NSString * const DBEnvironmentTest        = @"test";
NSString * const DBEnvironmentCustom      = @"custom";

NSString * const DBEnvironmentDevelopmentTitle  = @"DEVEL";
NSString * const DBEnvironmentReleaseTitle      = @"RELEASE";
NSString * const DBEnvironmentTestTitle         = @"TEST";
NSString * const DBEnvironmentCustomTitle       = @"CUSTOM";

NSString * const DBEnvironmentDidChangedNotification = @"DBEnvironmentDidChangedNotification";

NSString * const DBEnvironmentsKey = @"DBEnvironmentsKey";

NSString * const DBEnvironmentTypeKey = @"DBEnvironmentTypeKey";
NSString * const DBEnvironmentTypeWorkEnvironment = @"DBEnvironmentTypeWorkEnvironment";
NSString * const DBEnvironmentTypeWorkEnvironmentTitle = @"Working Environment";
NSString * const DBEnvironmentTypeContentEnvironment = @"DBEnvironmentTypeContentEnvironment";
NSString * const DBEnvironmentTypeContentEnvironmentTitle = @"Content Environment";

NSString * const DBEnvironmentNameKey = @"DBEnvironmentName";
NSString * const DBEnvironmentValueKey = @"DBEnvironmentValue";


@interface DBEnvironmentToolkit () {
    NSInteger _selectedItemIndex;
}

@property (strong) NSString *customValue;

@property (strong) NSString *basePresetWithPlaceholder;

@property (strong) NSMutableArray<NSMutableDictionary *> *presetsInfo;

@end

@implementation DBEnvironmentToolkit

@synthesize customValue, basePresetWithPlaceholder;
@synthesize presetsInfo;

-(instancetype) init {
    self = [super init];
    if (self) {
        presetsInfo = [[NSMutableArray alloc] initWithCapacity:DBEnvironmentCount];
        [self initializeDefaultConfigurationPresetInfo];
    }
    
    return self;
}

-(NSString*) applicationName {
    NSBundle* bundle = [NSBundle mainBundle];
    return [bundle.infoDictionary[@"CFBundleName"] lowercaseString];
}


-(NSString*) applicationVersion {
    return NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
}

-(void) initializeDefaultConfigurationPresetInfo {
    
    NSString* appName = self.applicationName;
    NSString* appVer  = self.applicationVersion;
    
    NSArray* defaultConfig = @[
        @{
            @"environment"      : DBEnvironmentTypeWorkEnvironmentTitle,
            @"environmentItems" : @[
                    @{
                        @"title" : [DBEnvironmentDevelopmentTitle lowercaseString],
                        @"value" : [NSString stringWithFormat:@"https://localhost/%@/conf/dev/%@/", appName, appVer]
                    },
                    @{
                        @"title" : [DBEnvironmentReleaseTitle lowercaseString],
                        @"value" : [NSString stringWithFormat:@"https://localhost/%@/conf/release/%@/", appName, appVer]
                    },
                    @{
                        @"title" : [DBEnvironmentTestTitle lowercaseString],
                        @"value" : [NSString stringWithFormat:@"https://localhost/%@/conf/tst/%@/", appName, appVer]
                    },
                    @{
                        @"title" : [DBEnvironmentCustomTitle lowercaseString],
                        @"value" : [NSString stringWithFormat:@"https://localhost/%@/conf/tst/%@/", appName, appVer]
                    }
            ],
            @"selected" : @(TEST_ITEM)
        }
        , @{
            @"environment"      : DBEnvironmentTypeContentEnvironmentTitle,
            @"environmentItems" : @[
                    @{
                        @"title" : @"devel",
                        @"value" : [NSString stringWithFormat:@"https://%@.localhost/devel/%@/", appName, appVer]
                    },
                    @{
                        @"title" : @"release",
                        @"value" : [NSString stringWithFormat:@"https://%@.localhost/release/%@/", appName, appVer]
                    },
                    @{
                        @"title" : @"test",
                        @"value" : [NSString stringWithFormat:@"https://%@.localhost/test/%@/", appName, appVer]
                    },
                    @{
                        @"title" : @"custom",
                        @"value" : [NSString stringWithFormat:@"https://%@.localhost/test_foo_bar/%@/", appName, appVer]
                    }
            ],
            @"selected" : @(3)
        }
    ];
    [self setEnvironments:defaultConfig];
}

-(NSString*) currentPreset {
    NSMutableString* preset = [[NSMutableString alloc] initWithCapacity:presetsInfo.count];
    
    NSArray<NSIndexPath*> *selIndexes = self.selectedItems;
    
    NSUInteger count = selIndexes.count;
    
    for (NSUInteger idx = 0; idx < count; idx++) {
        
        if (idx < count - 1) {
            
            NSIndexPath* idxPath = selIndexes[idx];
            NSString* title = presetsInfo[idxPath.section][@"environmentItems"][idxPath.row][@"title"];
            if (title) {
                [preset appendFormat:@"%@, ",title];
            }
            
        } else {
            // for the last component without comma
            NSIndexPath* idxPath = selIndexes[idx];
            NSString* title = presetsInfo[idxPath.section][@"environmentItems"][idxPath.row][@"title"];
            if (title) {
                [preset appendString:title];
            }
        }
        
    }
    
    return [[NSString stringWithString:preset] uppercaseString];
}


- (void) setEnvironments:(NSArray<NSDictionary *>*)environments {
    
    
    NSDictionary* firstPreset = environments.firstObject;
    
    NSMutableArray<NSMutableDictionary* > *prItems = firstPreset[@"environmentItems"];
    
    
    
    for (NSDictionary* cfgEnv in environments) {
        
        prItems = cfgEnv[@"environmentItems"];
    }
    
    //TODO: add additional checks for incoming data
    
    
    [self assignEnvironments:environments];
    
    [self initializeCustomItemsIfNeeded];
}


- (void) assignEnvironments:(NSArray<NSDictionary *>*)environments {
    [self.presetsInfo removeAllObjects];
    
    for (NSDictionary* cfgEnv in environments) {
        NSMutableDictionary *mutableCfgEnv = [[NSMutableDictionary alloc] initWithCapacity:cfgEnv.count];
        
        mutableCfgEnv[@"environment"] = cfgEnv[@"environment"];
        mutableCfgEnv[@"selected"] = cfgEnv[@"selected"];
        
        NSArray<NSDictionary*>* srcPrItems = cfgEnv[@"environmentItems"];
        NSMutableArray<NSMutableDictionary*>* prItems = [[NSMutableArray alloc] initWithCapacity:srcPrItems.count];
        
        for (NSDictionary* srcPrItem in srcPrItems) {
            [prItems addObject:[NSMutableDictionary dictionaryWithDictionary:srcPrItem]];
        }
        
        mutableCfgEnv[@"environmentItems"] = prItems;
 
        [self.presetsInfo addObject:mutableCfgEnv];
    }
}

- (void) initializeCustomItemsIfNeeded {
   
}

-(nullable NSDictionary*) getPresetItemWithTitle:(NSString*) title fromPresetItems:(NSArray<NSDictionary*> *) presetItems {
    if (!presetItems) {return nil;}
    
    NSInteger idx = [presetItems indexOfObjectPassingTest:^BOOL(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( [title isEqualToString:obj[@"title"]] ) {
            *stop = YES;
            return YES;
        }
        
        return NO;
    }];
    
    return idx != NSNotFound ? presetItems[idx] : nil;
}


- (BOOL) testItemWithTitle:(NSString*) title forPresetItems:(NSArray<NSDictionary*> *) presetItems {
    
    NSDictionary* item = [self getPresetItemWithTitle:title fromPresetItems:presetItems];
    if (!item) {
        return FALSE;
    }
    
    NSString* value = item[@"value"];
    if (!value) {
        return FALSE;
    }
    
    return [value length] > 0;
}

/**
 @brief Get number of presets available to process.
 @return number of presets or zero if no items.
 */
-(NSInteger) numberOfPresets {
    NSInteger num = 0;
    
    if (presetsInfo) {
        num = presetsInfo.count;
    }
    
    return num;
}



/// returns index paths selected for every configurable environment (Working or Content)
-(nullable NSArray<NSIndexPath*>*) selectedItems {
    
    if (!presetsInfo) {
        return nil;
    }
    
    if (presetsInfo.count == 0) {
        return @[];
    }
    
    NSMutableArray<NSIndexPath*> *resultArray = [[NSMutableArray alloc] initWithCapacity:presetsInfo.count];
    NSInteger countOfConfEnvironments =  presetsInfo.count;
    for (NSInteger envIndex = 0; envIndex < countOfConfEnvironments; envIndex++) {
        NSInteger evnSelectedItemIndex = [presetsInfo[envIndex][@"selected"] integerValue];
        NSIndexPath* selection = [NSIndexPath indexPathForRow:evnSelectedItemIndex inSection:envIndex];
        [resultArray addObject:selection];
    }
    
    return [NSArray arrayWithArray:resultArray];
}




-(NSInteger) numberOfItemsInPreset:(NSInteger) presetIndex {
    
    NSAssert( presetIndex >= 0 && presetIndex < self.presetsInfo.count, @"DBDebugToolkit: preset index is out of bounds.");
    
    NSInteger num = 0;
    
    NSMutableArray<NSMutableDictionary *> *prItems = self.presetsInfo[presetIndex][@"environmentItems"];
    if (prItems) {
        num = prItems.count;
    }
    
    return num;
}


-(NSString*) humanReadablePresetName:(NSString*) presetTypeName {
    if ([presetTypeName isEqualToString:DBEnvironmentTypeWorkEnvironment]) {
        return DBEnvironmentTypeWorkEnvironmentTitle;
        
    } else if ([presetTypeName isEqualToString:DBEnvironmentTypeContentEnvironment]) {
        return DBEnvironmentTypeContentEnvironmentTitle;
    }
    return presetTypeName;
}

-(NSString*) titleForPresetAtIndex:(NSInteger) presetIndex {
    NSAssert( presetIndex >= 0 && presetIndex < self.presetsInfo.count, @"DBDebugToolkit: preset index is out of bounds.");
    
    NSString* preset = self.presetsInfo[presetIndex][@"environment"];
    
    return [self humanReadablePresetName:preset];
}

-(NSDictionary*) presetItemForIndexPath:(NSIndexPath*) indexPath {
    NSAssert1( indexPath.section >= 0 && indexPath.section  < self.presetsInfo.count, @"DBDebugToolkit: preset index (%ld) is out of bounds.", (long)indexPath.section);
    NSMutableArray<NSMutableDictionary *> *prItems = self.presetsInfo[indexPath.section][@"environmentItems"];
    NSAssert1( indexPath.row >= 0 && indexPath.row < prItems.count, @"DBDebugToolkit: preset item index (%ld) is out of bounds.", (long)indexPath.row);
    
    return [NSDictionary dictionaryWithDictionary:prItems[indexPath.row]];
}

-(DBTitleValueTableViewCellDataSource*) dataSourceForItemAtIndexPath:(NSIndexPath*) indexPath {
    NSDictionary* item = [self presetItemForIndexPath:indexPath];
    return [DBTitleValueTableViewCellDataSource dataSourceWithTitle:item[@"title"] value:item[@"value"]];
}


-(void) setNewCustomValue:(NSString*) value forIndexPath:(NSIndexPath*) indexPath {
    NSMutableArray* presetItems = presetsInfo[indexPath.section][@"environmentItems"];
    if (!presetItems) { return; }
    
    NSUInteger customPresetItemIndex = [presetItems indexOfObjectPassingTest:^BOOL(NSMutableDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[@"title"] isEqualToString:@"custom"]) {
            *stop = YES;
            return TRUE;
        }
        return FALSE;
    }];
    
    if (customPresetItemIndex != NSNotFound) {
        // update custom value
        self.presetsInfo[indexPath.section][@"environmentItems"][customPresetItemIndex][@"value"] = value;
    } else {
        
        //add new custom value
        NSMutableDictionary* customPresetItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"custom",@"title",value,@"value", nil];
        [self.presetsInfo[indexPath.section][@"environmentItems"] addObject:customPresetItem];
    }
    
}


-(void) didSelectIndexPath:(NSIndexPath *)indexPath {
    presetsInfo[indexPath.section][@"selected"] = [NSNumber numberWithInteger:indexPath.row];
}

-(void) applyChanges {
    [self sendUpdateNotification];
}


-(void) sendUpdateNotification {
    NSMutableArray<NSDictionary *> *selectedPresets = [[NSMutableArray alloc] initWithCapacity:self.presetsInfo.count];
    NSArray<NSIndexPath *> *selected = self.selectedItems;
    NSMutableArray *selectedPres = [[NSMutableArray alloc] init];
    
    for (NSIndexPath* indexPath in selected) {
        
        
        NSString* selected = [NSString stringWithFormat:@"%lu", (unsigned long)[[NSNumber numberWithInteger:indexPath.row] integerValue]];
        
        [selectedPres addObject:selected];
        
        
        NSDictionary* presetItem = [self presetItemForIndexPath:indexPath];
        NSString* configEnvType = [self titleForPresetAtIndex:indexPath.section];
        
        
        [selectedPresets addObject:@{
                                     DBEnvironmentTypeKey  : configEnvType,
                                     DBEnvironmentNameKey  : presetItem[@"title"],
                                     DBEnvironmentValueKey : presetItem[@"value"]
                                     }];
    }
    
    DBDebugSettings *settings = [DBDebugSettings sharedInstance];
    [settings updateSelectedPresets:[[selectedPres valueForKey:@"description"] componentsJoinedByString:@","]];
    
    NSArray<NSDictionary *> * configPresets = [NSArray arrayWithArray:selectedPresets];
    NSDictionary *usrInfo = @{DBEnvironmentsKey : configPresets};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DBEnvironmentDidChangedNotification object:self userInfo:usrInfo];
}



#pragma mark -

@end
