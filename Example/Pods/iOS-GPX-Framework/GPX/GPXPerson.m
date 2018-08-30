//
//  GPXPerson.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXPerson.h"
#import "GPXElementSubclass.h"
#import "GPXEmail.h"
#import "GPXLink.h"


@implementation GPXPerson

@synthesize name = _name;
@synthesize email = _email;
@synthesize link = _link;


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _name = [self textForSingleChildElementNamed:@"name" xmlElement:element];
        _email = (GPXEmail *)[self childElementOfClass:[GPXEmail class] xmlElement:element];
        _link = (GPXLink *)[self childElementOfClass:[GPXLink class] xmlElement:element];
    }
    return self;
}


#pragma mark - Public methods



#pragma mark - tag

+ (NSString *)tagName
{
    return @"person";
}


#pragma mark - GPX

- (void)addChildTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [super addChildTagToGpx:gpx indentationLevel:indentationLevel];
    
    [self gpx:gpx addPropertyForValue:_name tagName:@"name" indentationLevel:indentationLevel];

    if (self.email) {
        [self.email gpx:gpx indentationLevel:indentationLevel];
    }
    if (self.link) {
        [self.link gpx:gpx indentationLevel:indentationLevel];
    }
}

@end
