//
//  GPXPoint.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXPoint.h"
#import "GPXElementSubclass.h"

@implementation GPXPoint {
    NSString *_elevationValue;
    NSString *_timeValue;
    NSString *_latitudeValue;
    NSString *_longitudeValue;
}

@synthesize elevation = _elevation;
@synthesize time = _time;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _elevationValue = [self textForSingleChildElementNamed:@"ele" xmlElement:element];
        _timeValue = [self textForSingleChildElementNamed:@"time" xmlElement:element];
        _latitudeValue = [self valueOfAttributeNamed:@"lat" xmlElement:element required:YES];
        _longitudeValue = [self valueOfAttributeNamed:@"lon" xmlElement:element required:YES];
    }
    return self;
}

+ (GPXPoint *)pointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXPoint *point = [GPXPoint new];
    point.latitude = latitude;
    point.longitude = longitude;
    return point;
}


#pragma mark - Public methods

- (CGFloat)elevation
{
    return [GPXType decimal:_elevationValue];
}

- (void)setElevation:(CGFloat)elevation
{
    _elevationValue = [GPXType valueForDecimal:elevation];
}

- (NSDate *)time
{
    return [GPXType dateTime:_timeValue];
}

- (void)setTime:(NSDate *)time
{
    _timeValue = [GPXType valueForDateTime:time];
}

- (CGFloat)latitude
{
    return [GPXType latitude:_latitudeValue];
}

- (void)setLatitude:(CGFloat)latitude
{
    _latitudeValue = [GPXType valueForLatitude:latitude];
}

- (CGFloat)longitude
{
    return [GPXType longitude:_longitudeValue];
}

- (void)setLongitude:(CGFloat)longitude
{
    _longitudeValue = [GPXType valueForLongitude:longitude];
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"pt";
}


#pragma mark - GPX

- (void)addOpenTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    NSMutableString *attribute = [NSMutableString stringWithString:@""];
    if (_latitudeValue) {
        [attribute appendFormat:@" lat=\"%@\"", _latitudeValue];
    }
    if (_longitudeValue) {
        [attribute appendFormat:@" lon=\"%@\"", _longitudeValue];
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
    
    [self gpx:gpx addPropertyForValue:_elevationValue tagName:@"ele" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_timeValue tagName:@"time" indentationLevel:indentationLevel];
}

@end
