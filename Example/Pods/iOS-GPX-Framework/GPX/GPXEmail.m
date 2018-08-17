//
//  GPXEmail.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXEmail.h"
#import "GPXElementSubclass.h"

@implementation GPXEmail

@synthesize emailID = _emailID;
@synthesize domain = _domain;


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _emailID = [self valueOfAttributeNamed:@"id" xmlElement:element required:YES];
        _domain = [self valueOfAttributeNamed:@"domain" xmlElement:element required:YES];
    }
    return self;
}

+ (GPXEmail *)emailWithID:(NSString *)emailID domain:(NSString *)domain
{
    GPXEmail *email = [GPXEmail new];
    email.emailID = emailID;
    email.domain = domain;
    return email;
}


#pragma mark - Public methods



#pragma mark - tag

+ (NSString *)tagName
{
    return @"email";
}


#pragma mark - GPX

- (void)addOpenTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    NSMutableString *attribute = [NSMutableString stringWithString:@""];
    if (_emailID) {
        [attribute appendFormat:@" id=\"%@\"", _emailID];
    }
    if (_domain) {
        [attribute appendFormat:@" domain=\"%@\"", _domain];
    }
    
    [gpx appendString:[NSString stringWithFormat:@"%@<%@%@>\r\n"
                       , [self indentForIndentationLevel:indentationLevel]
                       , [[self class] tagName]
                       , attribute
                       ]
     ];
}

@end
