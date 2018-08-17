//
//  GPXParser.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXParser.h"
#import "GPXConst.h"
#import "GPXElementSubclass.h"
#import "GPXRoot.h"
#import "TBXML.h"

@implementation GPXParser


#pragma mark - Instance

+ (GPXRoot *)parseGPXAtURL:(NSURL *)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return  [self parseGPXWithData:data];
}

+ (GPXRoot *)parseGPXAtPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    return [GPXParser parseGPXAtURL:url];
}

+ (GPXRoot *)parseGPXWithString:(NSString*)string
{
    TBXML *xml = [[TBXML alloc] initWithXMLString:string error:nil];
    if (xml.rootXMLElement) {
        return [[GPXRoot alloc] initWithXMLElement:xml.rootXMLElement parent:nil];
    }
    
    return nil;
}

+ (GPXRoot *)parseGPXWithData:(NSData*)data
{
    TBXML *xml = [[TBXML alloc] initWithXMLData:data error:nil];
    if (xml.rootXMLElement) {
        return [[GPXRoot alloc] initWithXMLElement:xml.rootXMLElement parent:nil];
    }
    
    return nil;
}

@end
