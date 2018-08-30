//
//  GPXCopyright.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXCopyright.h"
#import "GPXElementSubclass.h"

@implementation GPXCopyright {
    NSString *_yearValue;
}

@synthesize year = _year;
@synthesize license = _license;
@synthesize author = _author;


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _yearValue = [self textForSingleChildElementNamed:@"year" xmlElement:element];
        _license = [self textForSingleChildElementNamed:@"license" xmlElement:element];
        _author = [self valueOfAttributeNamed:@"author" xmlElement:element required:YES];
    }
    return self;
}

+ (GPXCopyright *)copyroghtWithAuthor:(NSString *)author
{
    GPXCopyright *copyright = [GPXCopyright new];
    copyright.author = author;
    return copyright;
}


#pragma mark - Public methods

- (NSDate *)year
{
    return [GPXType dateTime:_yearValue];
}

- (void)setYear:(NSDate *)year
{
    _yearValue = [GPXType valueForDateTime:year];
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"copyright";
}


#pragma mark - GPX

- (void)addOpenTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    NSMutableString *attribute = [NSMutableString stringWithString:@""];
    if (_author) {
        [attribute appendFormat:@" author=\"%@\"", _author];
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
    
    [self gpx:gpx addPropertyForValue:_yearValue tagName:@"year" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_license tagName:@"license" indentationLevel:indentationLevel];
}

@end
