//
//  GPXRoute.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXRoute.h"
#import "GPXElementSubclass.h"
#import "GPXLink.h"
#import "GPXExtensions.h"
#import "GPXRoutePoint.h"


@implementation GPXRoute {
    NSMutableArray *_links;
    NSMutableArray *_routepoints;
    NSString *_numberValue;
}

@synthesize name = _name;
@synthesize comment = _comment;
@synthesize desc = _desc;
@synthesize source = _source;
@synthesize links;
@synthesize number = _number;
@synthesize type = _type;
@synthesize extensions = _extensions;
@synthesize routepoints = _routepoints;


#pragma mark - Instance

- (id)init
{
    self = [super init];
    if (self) {
        _links = [NSMutableArray array];
        _routepoints = [NSMutableArray array];
    }
    return self;
}

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _name = [self textForSingleChildElementNamed:@"name" xmlElement:element];
        _comment = [self textForSingleChildElementNamed:@"cmt" xmlElement:element];
        _desc = [self textForSingleChildElementNamed:@"desc" xmlElement:element];
        _source = [self textForSingleChildElementNamed:@"src" xmlElement:element];
        
        NSMutableArray *array1 = [NSMutableArray array];
        [self childElementsOfClass:[GPXLink class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array1 addObject:element];
                         }];
        _links = array1;
        
        _numberValue = [self textForSingleChildElementNamed:@"number" xmlElement:element];
        _type = [self textForSingleChildElementNamed:@"type" xmlElement:element];
        _extensions = (GPXExtensions *)[self childElementOfClass:[GPXExtensions class] xmlElement:element];

        NSMutableArray *array2 = [NSMutableArray array];
        [self childElementsOfClass:[GPXRoutePoint class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array2 addObject:element];
                         }];
        _routepoints = array2;
    }
    return self;
}


#pragma mark - Public methods

- (NSInteger)number
{
    return [GPXType nonNegativeInteger:_numberValue];
}

- (void)setNumber:(NSInteger)number
{
    _numberValue = [GPXType valueForNonNegativeInteger:number];
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

- (GPXRoutePoint *)newRoutepointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXRoutePoint *routepoint = [GPXRoutePoint routepointWithLatitude:latitude longitude:longitude];
    [self addRoutepoint:routepoint];
    return routepoint;
}

- (void)addRoutepoint:(GPXRoutePoint *)routepoint
{
    if (routepoint) {
        NSUInteger index = [_routepoints indexOfObject:routepoint];
        if (index == NSNotFound) {
            routepoint.parent = self;
            [_routepoints addObject:routepoint];
        }
    }
}

- (void)addRoutepoints:(NSArray *)array
{
    for (GPXRoutePoint *routepoint in array) {
        [self addRoutepoint:routepoint];
    }
}

- (void)removeRoutepoint:(GPXRoute *)routepoint
{
    NSUInteger index = [_routepoints indexOfObject:routepoint];
    if (index != NSNotFound) {
        routepoint.parent = nil;
        [_routepoints removeObject:routepoint];
    }
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"rte";
}


#pragma mark - GPX

- (void)addChildTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [super addChildTagToGpx:gpx indentationLevel:indentationLevel];
    
    [self gpx:gpx addPropertyForValue:_name tagName:@"name" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_comment tagName:@"cmt" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_desc tagName:@"desc" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_source tagName:@"src" indentationLevel:indentationLevel];
    
    for (GPXLink *link in self.links) {
        [link gpx:gpx indentationLevel:indentationLevel];
    }

    [self gpx:gpx addPropertyForValue:_numberValue tagName:@"number" indentationLevel:indentationLevel];
    [self gpx:gpx addPropertyForValue:_type tagName:@"type" indentationLevel:indentationLevel];

    if (self.extensions) {
        [self.extensions gpx:gpx indentationLevel:indentationLevel];
    }

    for (GPXRoutePoint *routepoint in self.routepoints) {
        [routepoint gpx:gpx indentationLevel:indentationLevel];
    }
}

@end
