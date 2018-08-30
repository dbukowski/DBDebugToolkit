//
//  GPXBounds.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXBounds.h"
#import "GPXElementSubclass.h"

@implementation GPXBounds {
    NSString *_minLatitudeValue;
    NSString *_minLongitudeValue;
    NSString *_maxLatitudeValue;
    NSString *_maxLongitudeValue;
}

@synthesize minLatitude = _minLatitude;
@synthesize minLongitude = _minLongitude;
@synthesize maxLatitude = _maxLatitude;
@synthesize maxLongitude = _maxLongitude;


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _minLatitudeValue = [self valueOfAttributeNamed:@"minlat" xmlElement:element required:YES];
        _minLongitudeValue = [self valueOfAttributeNamed:@"minlon" xmlElement:element required:YES];
        _maxLatitudeValue = [self valueOfAttributeNamed:@"maxlat" xmlElement:element required:YES];
        _maxLongitudeValue = [self valueOfAttributeNamed:@"maxlon" xmlElement:element required:YES];
    }
    return self;
}

+ (GPXBounds *)boundsWithMinLatitude:(CGFloat)minLatitude minLongitude:(CGFloat)minLongitude maxLatitude:(CGFloat)maxLatitude maxLongitude:(CGFloat)maxLongitude
{
    GPXBounds *bounds = [GPXBounds new];
    bounds.minLatitude = minLatitude;
    bounds.minLongitude = minLongitude;
    bounds.maxLatitude = maxLatitude;
    bounds.maxLongitude = maxLongitude;
    return bounds;
}


#pragma mark - Public methods

- (CGFloat)minLatitude
{
    return [GPXType latitude:_minLatitudeValue];
}

- (void)setMinLatitude:(CGFloat)minLatitude
{
    _minLatitudeValue = [GPXType valueForLatitude:minLatitude];
}

- (CGFloat)minLongitude
{
    return [GPXType longitude:_minLongitudeValue];
}

- (void)setMinLongitude:(CGFloat)minLongitude
{
    _minLongitudeValue = [GPXType valueForLongitude:minLongitude];
}

- (CGFloat)maxLatitude
{
    return [GPXType latitude:_maxLatitudeValue];
}

- (void)setMaxlat:(CGFloat)maxLatitude
{
    _maxLatitudeValue = [GPXType valueForLatitude:maxLatitude];
}

- (CGFloat)maxLongitude
{
    return [GPXType longitude:_maxLongitudeValue];
}

- (void)setMaxlon:(CGFloat)maxLongitude
{
    _maxLongitudeValue = [GPXType valueForLongitude:maxLongitude];
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"bounds";
}


#pragma mark - GPX

- (void)addOpenTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    NSMutableString *attribute = [NSMutableString stringWithString:@""];
    if (_minLatitudeValue) {
        [attribute appendFormat:@" minlat=\"%@\"", _minLatitudeValue];
    }
    if (_minLongitudeValue) {
        [attribute appendFormat:@" minlon=\"%@\"", _minLongitudeValue];
    }
    if (_maxLatitudeValue) {
        [attribute appendFormat:@" maxlat=\"%@\"", _maxLatitudeValue];
    }
    if (_maxLongitudeValue) {
        [attribute appendFormat:@" maxlot=\"%@\"", _maxLongitudeValue];
    }
    
    [gpx appendString:[NSString stringWithFormat:@"%@<%@%@>\r\n"
                       , [self indentForIndentationLevel:indentationLevel]
                       , [[self class] tagName]
                       , attribute
                       ]
     ];
}

@end
