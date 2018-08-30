//
//  GPXMetadata.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXMetadata.h"
#import "GPXElementSubclass.h"
#import "GPXAuthor.h"
#import "GPXCopyright.h"
#import "GPXLink.h"
#import "GPXBounds.h"
#import "GPXExtensions.h"

@implementation GPXMetadata {
    NSString *_timeValue;
}

@synthesize name = _name;
@synthesize desc = _desc;
@synthesize author = _author;
@synthesize copyright = _copyright;
@synthesize link = _link;
@synthesize time = _time;
@synthesize keyword = _keyword;
@synthesize bounds = _bounds;
@synthesize extensions = _extensions;


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _name = [self textForSingleChildElementNamed:@"name" xmlElement:element];
        _desc = [self textForSingleChildElementNamed:@"desc" xmlElement:element];
        _author = (GPXAuthor *)[self childElementOfClass:[GPXAuthor class] xmlElement:element];
        _copyright = (GPXCopyright *)[self childElementOfClass:[GPXCopyright class] xmlElement:element];
        _link = (GPXLink *)[self childElementOfClass:[GPXLink class] xmlElement:element];
        _timeValue = [self textForSingleChildElementNamed:@"time" xmlElement:element];
        _keyword = [self textForSingleChildElementNamed:@"keyword" xmlElement:element];
        _bounds = (GPXBounds *)[self childElementOfClass:[GPXBounds class] xmlElement:element];
        _extensions = (GPXExtensions *)[self childElementOfClass:[GPXExtensions class] xmlElement:element];
    }
    return self;
}


#pragma mark - Public methods

- (NSDate *)time
{
    return [GPXType dateTime:_timeValue];
}

- (void)setTime:(NSDate *)time
{
    _timeValue = [GPXType valueForDateTime:time];
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"metadata";
}


#pragma mark - GPX

- (void)addChildTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [super addChildTagToGpx:gpx indentationLevel:indentationLevel];
    
    [self gpx:gpx addPropertyForValue:_name tagName:@"name" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_desc tagName:@"desc" indentationLevel:indentationLevel];

    if (self.author) {
        [self.author gpx:gpx indentationLevel:indentationLevel];
    }

    if (self.copyright) {
        [self.copyright gpx:gpx indentationLevel:indentationLevel];
    }

    if (self.link) {
        [self.link gpx:gpx indentationLevel:indentationLevel];
    }

    [self gpx:gpx addPropertyForValue:_timeValue defaultValue:@"0" tagName:@"time" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_keyword tagName:@"keyword" indentationLevel:indentationLevel];

    if (self.bounds) {
        [self.bounds gpx:gpx indentationLevel:indentationLevel];
    }

    if (self.extensions) {
        [self.extensions gpx:gpx indentationLevel:indentationLevel];
    }
}


@end
