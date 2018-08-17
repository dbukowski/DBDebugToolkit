//
//  GPXWaypoint.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXWaypoint.h"
#import "GPXElementSubclass.h"
#import "GPXLink.h"
#import "GPXExtensions.h"

@implementation GPXWaypoint {
    NSString *_elevationValue;
    NSString *_timeValue;
    NSString *_magneticVariationValue;
    NSString *_geoidHeightValue;
    NSMutableArray *_links;
    NSString *_fixValue;
    NSString *_satellitesValue;
    NSString *_horizontalDilutionValue;
    NSString *_verticalDilutionValue;
    NSString *_positionDilutionValue;
    NSString *_ageOfDGPSDataValue;
    NSString *_DGPSidValue;
    NSString *_latitudeValue;
    NSString *_longitudeValue;
}

@synthesize elevation = _elevation;
@synthesize time = _time;
@synthesize magneticVariation = _magneticVariation;
@synthesize geoidHeight = _geoidHeight;
@synthesize name = _name;
@synthesize comment = _comment;
@synthesize desc = _desc;
@synthesize source = _source;
@synthesize links = _links;
@synthesize symbol = _symbol;
@synthesize type = _type;
@synthesize fix = _fix;
@synthesize satellites = _satellites;
@synthesize horizontalDilution = _horizontalDilution;
@synthesize verticalDilution = _verticalDilution;
@synthesize positionDilution = _positionDilution;
@synthesize ageOfDGPSData = _ageOfDGPSData;
@synthesize DGPSid = _DGPSid;
@synthesize extensions = _extensions;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _elevationValue = [self textForSingleChildElementNamed:@"ele" xmlElement:element];
        _timeValue = [self textForSingleChildElementNamed:@"time" xmlElement:element];
        _magneticVariationValue = [self textForSingleChildElementNamed:@"magvar" xmlElement:element];
        _geoidHeightValue = [self textForSingleChildElementNamed:@"geoidheight" xmlElement:element];
        _name = [self textForSingleChildElementNamed:@"name" xmlElement:element];
        _comment = [self textForSingleChildElementNamed:@"cmt" xmlElement:element];
        _desc = [self textForSingleChildElementNamed:@"desc" xmlElement:element];
        _source = [self textForSingleChildElementNamed:@"src" xmlElement:element];

        NSMutableArray *array = [NSMutableArray array];
        [self childElementsOfClass:[GPXLink class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array addObject:element];
                         }];
        _links = array;
        
        _symbol = [self textForSingleChildElementNamed:@"sym" xmlElement:element];
        _type = [self textForSingleChildElementNamed:@"type" xmlElement:element];
        _fixValue = [self textForSingleChildElementNamed:@"fix" xmlElement:element];
        _satellitesValue = [self textForSingleChildElementNamed:@"sat" xmlElement:element];
        _horizontalDilutionValue = [self textForSingleChildElementNamed:@"hdop" xmlElement:element];
        _verticalDilutionValue = [self textForSingleChildElementNamed:@"vdop" xmlElement:element];
        _positionDilutionValue = [self textForSingleChildElementNamed:@"pdop" xmlElement:element];
        _ageOfDGPSDataValue = [self textForSingleChildElementNamed:@"ageofdgpsdata" xmlElement:element];
        _DGPSidValue = [self textForSingleChildElementNamed:@"dgpsid" xmlElement:element];
        _extensions = (GPXExtensions *)[self childElementOfClass:[GPXExtensions class] xmlElement:element];

        _latitudeValue = [self valueOfAttributeNamed:@"lat" xmlElement:element required:YES];
        _longitudeValue = [self valueOfAttributeNamed:@"lon" xmlElement:element required:YES];

    }
    return self;
}

+ (GPXWaypoint *)waypointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXWaypoint *waypoint = [GPXWaypoint new];
    waypoint.latitude = latitude;
    waypoint.longitude = longitude;
    return waypoint;
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

- (CGFloat)magneticVariation
{
    return [GPXType degress:_magneticVariationValue];
}

- (void)setMagneticVariation:(CGFloat)magneticVariation
{
    _magneticVariationValue = [GPXType valueForDegress:magneticVariation];
}

- (CGFloat)geoidHeight
{
    return [GPXType decimal:_geoidHeightValue];
}

- (void)setGeoidHeight:(CGFloat)geoidHeight
{
    _geoidHeightValue = [GPXType valueForDecimal:geoidHeight];
}

- (GPXLink *)newLinkWithHref:(NSString *)href
{
    GPXLink *link = [GPXLink linkWithHref:href];
    [self addLink:link];
    return link;
}

- (void)addLink:(GPXLink *)link
{
    if (link) {
        NSUInteger index = [_links indexOfObject:link];
        if (index == NSNotFound) {
            link.parent = self;
            [_links addObject:link];
        }
    }
}

- (void)addLinks:(NSArray *)array
{
    for (GPXLink *link in array) {
        [self addLink:link];
    }
}

- (void)removeLink:(GPXLink *)link
{
    NSUInteger index = [_links indexOfObject:link];
    if (index != NSNotFound) {
        link.parent = nil;
        [_links removeObject:link];
    }
}

- (NSInteger)fix
{
    return [GPXType fix:_fixValue];
}

- (void)setFix:(NSInteger)fix
{
    _fixValue = [GPXType valueForFix:fix];
}

- (NSInteger)satellites
{
    return [GPXType nonNegativeInteger:_satellitesValue];
}

- (void)setSatellites:(NSInteger)satellites
{
    _satellitesValue = [GPXType valueForNonNegativeInteger:satellites];
}

- (CGFloat)horizontalDilution
{
    return [GPXType decimal:_horizontalDilutionValue];
}

- (void)setHorizontalDilution:(CGFloat)horizontalDilution
{
    _horizontalDilutionValue = [GPXType valueForDecimal:horizontalDilution];
}

- (CGFloat)verticalDilution
{
    return [GPXType decimal:_verticalDilutionValue];
}

- (void)setVerticalDilution:(CGFloat)verticalDilution
{
    _verticalDilutionValue = [GPXType valueForDecimal:verticalDilution];
}

- (CGFloat)positionDilution
{
    return [GPXType decimal:_positionDilutionValue];
}

- (void)setPositionDilution:(CGFloat)positionDilution
{
    _positionDilutionValue = [GPXType valueForDecimal:positionDilution];
}

- (CGFloat)ageOfDGPSData
{
    return [GPXType decimal:_ageOfDGPSDataValue];
}

- (void)setAgeOfDGPSData:(CGFloat)ageOfDGPSData
{
    _ageOfDGPSDataValue = [GPXType valueForDecimal:ageOfDGPSData];
}

- (NSInteger)DGPSid
{
    return [GPXType dgpsStation:_DGPSidValue];
}

- (void)setDGPSid:(NSInteger)DGPSid
{
    _DGPSidValue = [GPXType valueForDgpsStation:DGPSid];
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
    return @"wpt";
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
    [self gpx:gpx addPropertyForValue:_magneticVariationValue tagName:@"magvar" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_geoidHeightValue tagName:@"geoidheight" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_name tagName:@"name" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_comment tagName:@"cmt" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_desc tagName:@"desc" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_source tagName:@"src" indentationLevel:indentationLevel];
    
    for (GPXLink *link in self.links) {
        [link gpx:gpx indentationLevel:indentationLevel];
    }

    [self gpx:gpx addPropertyForValue:_symbol tagName:@"sym" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_type tagName:@"type" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_fixValue tagName:@"fix" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_satellitesValue tagName:@"sat" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_horizontalDilutionValue tagName:@"hdop" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_verticalDilutionValue tagName:@"vdop" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_positionDilutionValue tagName:@"pdop" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_ageOfDGPSDataValue tagName:@"ageofdgpsdata" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_DGPSidValue tagName:@"dgpsid" indentationLevel:indentationLevel];

    if (self.extensions) {
        [self.extensions gpx:gpx indentationLevel:indentationLevel];
    }

}

@end
