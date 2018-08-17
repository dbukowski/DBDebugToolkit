//
//  GPXLink.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXLink.h"
#import "GPXElementSubclass.h"

@implementation GPXLink

@synthesize text = _text;
@synthesize mimetype = _mimetype;
@synthesize href = _href;


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _text = [self textForSingleChildElementNamed:@"text" xmlElement:element];
        _mimetype = [self textForSingleChildElementNamed:@"type" xmlElement:element];
        _href = [self valueOfAttributeNamed:@"href" xmlElement:element required:YES];
    }
    return self;
}

+ (GPXLink *)linkWithHref:(NSString *)href
{
    GPXLink *link = [GPXLink new];
    link.href = href;
    return link;
}


#pragma mark - Public methods



#pragma mark - tag

+ (NSString *)tagName
{
    return @"link";
}


#pragma mark - GPX

- (void)addOpenTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    NSMutableString *attribute = [NSMutableString stringWithString:@""];
    if (_href) {
        [attribute appendFormat:@" href=\"%@\"", _href];
    }
    
    [gpx appendString:[NSString stringWithFormat:@"%@<%@%@>\r\n"
                       , [self indentForIndentationLevel:indentationLevel]
                       , [[self class] tagName]
                       , attribute
                       ]
     ];
}

- (void)addChildTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [super addChildTagToGpx:gpx indentationLevel:indentationLevel];

    [self gpx:gpx addPropertyForValue:_text tagName:@"text" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_mimetype tagName:@"type" indentationLevel:indentationLevel];
}

@end
