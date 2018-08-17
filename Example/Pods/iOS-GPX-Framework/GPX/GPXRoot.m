//
//  GPXRoot.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXRoot.h"
#import "GPXElementSubclass.h"
#import "GPXMetadata.h"
#import "GPXWaypoint.h"
#import "GPXRoute.h"
#import "GPXTrack.h"
#import "GPXExtensions.h"


@implementation GPXRoot {
    NSMutableArray *_waypoints;
    NSMutableArray *_routes;
    NSMutableArray *_tracks;
}

@synthesize schema = _schema;
@synthesize version = _version;
@synthesize creator = _creator;
@synthesize metadata = _metadata;
@synthesize waypoints = _waypoints;
@synthesize routes = _routes;
@synthesize tracks = _tracks;
@synthesize extensions = _extensions;


#pragma mark - Instance


- (id)init
{
    self = [super init];
    if (self) {
        _version = @"1.1";
        _creator = @"http://gpxframework.com";
        _waypoints = [NSMutableArray array];
        _routes = [NSMutableArray array];
        _tracks = [NSMutableArray array];
    }
    return self;
}

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _version = [self valueOfAttributeNamed:@"version" xmlElement:element required:YES];
        _creator = [self valueOfAttributeNamed:@"creator" xmlElement:element required:YES];

        _metadata = (GPXMetadata *)[self childElementOfClass:[GPXMetadata class] xmlElement:element];
        
        NSMutableArray *array1 = [NSMutableArray array];
        [self childElementsOfClass:[GPXWaypoint class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array1 addObject:element];
                         }];
        _waypoints = array1;
        
        NSMutableArray *array2 = [NSMutableArray array];
        [self childElementsOfClass:[GPXRoute class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array2 addObject:element];
                         }];
        _routes = array2;
        
        NSMutableArray *array3 = [NSMutableArray array];
        [self childElementsOfClass:[GPXTrack class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array3 addObject:element];
                         }];
        _tracks = array3;

        _extensions = (GPXExtensions *)[self childElementOfClass:[GPXExtensions class] xmlElement:element];

    }
    return self;
}

+ (GPXRoot *)rootWithCreator:(NSString *)creator;
{
    GPXRoot *root = [GPXRoot new];
    root.creator = creator;
    return root;
}


#pragma mark - Public methods

- (NSString *)schema
{
    return @"http://www.topografix.com/GPX/1/1";
}

- (GPXWaypoint *)newWaypointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXWaypoint *waypoint = [GPXWaypoint waypointWithLatitude:latitude longitude:longitude];
    [self addWaypoint:waypoint];
    return waypoint;
}

- (void)addWaypoint:(GPXWaypoint *)waypoint
{
    if (waypoint) {
        NSUInteger index = [_waypoints indexOfObject:waypoint];
        if (index == NSNotFound) {
            waypoint.parent = self;
            [_waypoints addObject:waypoint];
        }
    }
}

- (void)addWaypoints:(NSArray *)array
{
    for (GPXWaypoint *wpt in array) {
        [self addWaypoint:wpt];
    }
}

- (void)removeWaypoint:(GPXWaypoint *)waypoint
{
    NSUInteger index = [_waypoints indexOfObject:waypoint];
    if (index != NSNotFound) {
        waypoint.parent = nil;
        [_waypoints removeObject:waypoint];
    }
}

- (GPXRoute *)newRoute
{
    GPXRoute *route = [GPXRoute new];
    [self addRoute:route];
    return route;
}

- (void)addRoute:(GPXRoute *)route
{
    if (route) {
        NSUInteger index = [_routes indexOfObject:route];
        if (index == NSNotFound) {
            route.parent = self;
            [_routes addObject:route];
        }
    }
}

- (void)addRoutes:(NSArray *)array
{
    for (GPXRoute *rte in array) {
        [self addRoute:rte];
    }
}

- (void)removeRoute:(GPXRoute *)route
{
    NSUInteger index = [_routes indexOfObject:route];
    if (index != NSNotFound) {
        route.parent = nil;
        [_routes removeObject:route];
    }
}

- (GPXTrack *)newTrack
{
    GPXTrack *track = [GPXTrack new];
    [self addTrack:track];
    return track;
}

- (void)addTrack:(GPXTrack *)track
{
    if (track) {
        NSUInteger index = [_tracks indexOfObject:track];
        if (index == NSNotFound) {
            track.parent = self;
            [_tracks addObject:track];
        }
    }
}

- (void)addTracks:(NSArray *)array
{
    for (GPXTrack *trk in array) {
        [self addTrack:trk];
    }
}

- (void)removeTrack:(GPXTrack *)track
{
    NSUInteger index = [_tracks indexOfObject:track];
    if (index != NSNotFound) {
        track.parent = nil;
        [_tracks removeObject:track];
    }
}



#pragma mark - Tag

+ (NSString *)tagName
{
    return @"gpx";
}


#pragma mark - GPX

- (void)addOpenTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    NSMutableString *attribute = [NSMutableString stringWithString:@""];
    if (self.schema) {
        [attribute appendFormat:@" xmlns=\"%@\"", self.schema];
    }
    if (self.version) {
        [attribute appendFormat:@" version=\"%@\"", self.version];
    }
    if (self.creator) {
        [attribute appendFormat:@" creator=\"%@\"", self.creator];
    }
    
    [gpx appendString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n"];
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
    
    if (self.metadata) {
        [self.metadata gpx:gpx indentationLevel:indentationLevel];
    }
    for (GPXWaypoint *waypoint in self.waypoints) {
        [waypoint gpx:gpx indentationLevel:indentationLevel];
    }
    for (GPXRoute *route in self.routes) {
        [route gpx:gpx indentationLevel:indentationLevel];
    }
    for (GPXTrack *track in self.tracks) {
        [track gpx:gpx indentationLevel:indentationLevel];
    }
    if (self.extensions) {
        [self.extensions gpx:gpx indentationLevel:indentationLevel];
    }
}

@end
