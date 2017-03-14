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
#import "DBKeychainToolkit.h"

@interface DBKeychainToolkit ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, id> *keychainValues;
@property (nonatomic, strong) NSMutableArray *keychainKeys;

@end

@implementation DBKeychainToolkit

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupKeychainValues];
    }
    
    return self;
}

- (void)setupKeychainValues {
    self.keychainValues = [NSMutableDictionary dictionary];
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnAttributes,
                                  (__bridge id)kSecMatchLimitAll, (__bridge id)kSecMatchLimit,
                                  (__bridge id)kCFBooleanTrue, (__bridge id)kSecReturnData,
                                  nil];
    NSArray *secItemClasses = [self secItemClasses];
    for (id secItemClass in secItemClasses) {
        [query setObject:secItemClass forKey:(__bridge id)kSecClass];
        CFTypeRef result = NULL;
        if (SecItemCopyMatching((__bridge CFDictionaryRef)query, &result) != errSecItemNotFound) {
            NSArray *dictionaries = (__bridge NSArray *)result;
            for (NSDictionary *dictionary in dictionaries) {
                NSString *account;
                id accountObject = dictionary[(__bridge id)kSecAttrAccount];
                if ([accountObject isKindOfClass:[NSData class]]) {
                    account = [[NSString alloc] initWithData:accountObject encoding:NSUTF8StringEncoding];
                } else {
                    account = (NSString *)accountObject;
                }
                NSData *data = dictionary[(__bridge id)kSecValueData];
                if (data.length > 0 && account.length > 0) {
                    id unarchivedObject = nil;
                    @try { // Needed on iOS 8.0, where unarchiveObjectWithData: throws exception.
                        unarchivedObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    } @catch (NSException *) {
                        // Do nothing.
                    }
                    NSString *decodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    self.keychainValues[account] = unarchivedObject ? unarchivedObject : (decodedString ? decodedString : data);
                }
            }
        }
        if (result != NULL) {
            CFRelease(result);
        }
    }
    self.keychainKeys = [NSMutableArray arrayWithArray:[self.keychainValues.allKeys sortedArrayUsingSelector:@selector(compare:)]];
}

#pragma mark - DBTitleValueListViewModel

- (NSString *)viewTitle {
    return @"Keychain";
}

- (NSInteger)numberOfItems {
    return self.keychainValues.count;
}

- (DBTitleValueTableViewCellDataSource *)dataSourceForItemAtIndex:(NSInteger)index {
    NSString *key = self.keychainKeys[index];
    NSString *value = [NSString stringWithFormat:@"%@", self.keychainValues[key]];
    return [DBTitleValueTableViewCellDataSource dataSourceWithTitle:key
                                                              value:value];
}

- (void)handleClearAction {
    for (NSString *key in self.keychainKeys) {
        [self removeObjectFromKeychainWithKey:key];
    }
    [self.keychainKeys removeAllObjects];
    [self.keychainValues removeAllObjects];
}

- (void)handleDeleteItemActionAtIndex:(NSInteger)index {
    NSString *key = self.keychainKeys[index];
    [self removeObjectFromKeychainWithKey:key];
    [self.keychainKeys removeObject:key];
    [self.keychainValues removeObjectForKey:key];
}

- (NSString *)emptyListDescriptionString {
    return @"There are no entries in the keychain.";
}

#pragma mark - Private methods

- (void)removeObjectFromKeychainWithKey:(NSString *)key {
    NSMutableDictionary *searchDictionary = [NSMutableDictionary dictionary];
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    NSArray *secItemClasses = [self secItemClasses];
    for (id secItemClass in secItemClasses) {
        [searchDictionary setObject:secItemClass forKey:(__bridge id)kSecClass];
        SecItemDelete((CFDictionaryRef)searchDictionary);
    }
}

- (NSArray *)secItemClasses {
    return [NSArray arrayWithObjects:
            (__bridge id)kSecClassGenericPassword,
            (__bridge id)kSecClassInternetPassword,
            (__bridge id)kSecClassCertificate,
            (__bridge id)kSecClassKey,
            (__bridge id)kSecClassIdentity,
            nil];
}

@end
