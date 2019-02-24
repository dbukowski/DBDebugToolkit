//
//  DBJsonNode.m
//  DBDebugToolkit
//
//  Created by Konrad Zdunczyk on 23/02/2019.
//  Copyright © 2019 Konrad Zdunczyk
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

#import "DBJsonNode.h"

@interface DBJsonNode ()

@property(nonatomic, copy) NSString *nodeName;

@end

@implementation DBJsonNode

+ (instancetype)jsonNodeWithJsonString:(NSString *)jsonString {
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error;
    NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data ?: [NSData data]
                                                                options:NSJSONReadingAllowFragments
                                                                  error:&error];

    if (error) {
        return nil;
    } else {
        return [DBJsonNode jsonNodeWithJson:json];
    }
}

+ (instancetype)jsonNodeWithJson:(id)json {
    return [[DBJsonNode alloc] initWithName:@"JSON ROOT" andJson:json];
}

- (instancetype)initWithName:(NSString *)name andJson:(id)json {
    self = [super init];
    if (self) {
        _nodeName = name;

        if (!json) {
            _jsonNodeType = DBJsonNodeTypeNull;
            _value = nil;
        } else {
            _jsonNodeType = [DBJsonNode getTypeOfJson:json];

            switch (_jsonNodeType) {
                case DBJsonNodeTypeNull:
                    _value = nil;
                    break;
                case DBJsonNodeTypeString:
                    _value = json;
                    break;
                case DBJsonNodeTypeNumber:
                    _value = json;
                    break;
                case DBJsonNodeTypeBool:
                    _value = json;
                    break;
                case DBJsonNodeTypeObject: {
                    NSDictionary *jsonObject = json;
                    NSMutableArray *subnodes = [NSMutableArray array];
                    [jsonObject enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        DBJsonNode *node = [[DBJsonNode alloc] initWithName:key andJson:obj];

                        if (node) {
                            [subnodes addObject:node];
                        }
                    }];

                    _value = [NSArray arrayWithArray:subnodes];
                    break;
                }
                case DBJsonNodeTypeArray: {
                    NSArray *jsonArray = json;
                    NSMutableArray *subnodes = [NSMutableArray array];
                    [jsonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString *name = [NSString stringWithFormat:@"Index %lu", (unsigned long)idx];
                        DBJsonNode *node = [[DBJsonNode alloc] initWithName:name andJson:obj];

                        if (node) {
                            [subnodes addObject:node];
                        }
                    }];

                    _value = [NSArray arrayWithArray:subnodes];
                    break;
                }
            }
        }
    }
    return self;
}

- (NSString*)nodeName {
    return _nodeName;
}

- (NSString*)nodeValueDescription {
    switch (self.jsonNodeType) {
        case DBJsonNodeTypeNull:
            return @"null";
            break;
        case DBJsonNodeTypeString: {
            NSString *value = self.value;

            return value;
        }
        case DBJsonNodeTypeNumber: {
            NSNumber *value = self.value;

            return [value stringValue];
        }
        case DBJsonNodeTypeBool: {
            NSNumber *value = self.value;

            return [value boolValue] ? @"true" : @"false";
        }
        case DBJsonNodeTypeObject: {
            NSArray *jsonArray = self.value;

            return [NSString stringWithFormat:@"Keys: %lu", (unsigned long)jsonArray.count];
        }
        case DBJsonNodeTypeArray:{
            NSArray *jsonArray = self.value;

            return [NSString stringWithFormat:@"Elements: %lu", (unsigned long)jsonArray.count];
        }
    }
}

- (NSString*)nodeValueTypeDescription {
    switch (self.jsonNodeType) {
        case DBJsonNodeTypeNull:
            return @"null";
            break;
        case DBJsonNodeTypeString:
            return @"string";
            break;
        case DBJsonNodeTypeNumber:
            return @"number";
            break;
        case DBJsonNodeTypeBool:
            return @"bool";
            break;
        case DBJsonNodeTypeObject:
            return @"object";
            break;
        case DBJsonNodeTypeArray:
            return @"array";
            break;
    }
}

+ (DBJsonNodeType)getTypeOfJson:(id)json {
    if (!json) {
        return DBJsonNodeTypeNull;
    }

    if ([json isKindOfClass:[NSDictionary class]]) {
        return DBJsonNodeTypeObject;
    } else if ([json isKindOfClass:[NSArray class]]) {
        return DBJsonNodeTypeArray;
    } else if ([json isKindOfClass:[NSString class]]) {
        return DBJsonNodeTypeString;
    } else if ([json isKindOfClass:[NSNumber class]]) {
        if (CFGetTypeID((__bridge CFTypeRef)(json)) == CFBooleanGetTypeID()) {
            return DBJsonNodeTypeBool;
        }

        return DBJsonNodeTypeNumber;
    } else if ([json isKindOfClass:[NSNull class]]) {
        return DBJsonNodeTypeNull;
    } else {
        return DBJsonNodeTypeNull;
    }
}

@end
