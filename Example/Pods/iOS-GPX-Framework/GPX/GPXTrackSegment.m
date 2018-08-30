//
//  GPXTrackSegment.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXTrackSegment.h"
#import "GPXElementSubclass.h"
#import "GPXExtensions.h"
#import "GPXTrackPoint.h"

@implementation GPXTrackSegment {
    NSMutableArray *_trackpoints;
}

@synthesize trackpoints = _trackpoints;
@synthesize extensions = _extensions;


#pragma mark - Instance

- (id)init
{
    self = [super init];
    if (self) {
        _trackpoints = [NSMutableArray array];
    }
    return self;
}

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        _extensions = (GPXExtensions *)[self childElementOfClass:[GPXExtensions class] xmlElement:element];
        
        NSMutableArray *array1 = [NSMutableArray array];
        [self childElementsOfClass:[GPXTrackPoint class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array1 addObject:element];
                         }];
        _trackpoints = array1;

    }
    return self;
}


#pragma mark - Public methods

- (GPXTrackPoint *)newTrackpointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXTrackPoint *trackpoint = [GPXTrackPoint trackpointWithLatitude:latitude longitude:longitude];
    [self addTrackpoint:trackpoint];
    return trackpoint;
}

- (void)addTrackpoint:(GPXTrackPoint *)trackpoint
{
    if (trackpoint) {
        NSUInteger index = [_trackpoints indexOfObject:trackpoint];
        if (index == NSNotFound) {
            trackpoint.parent = self;
            [_trackpoints addObject:trackpoint];
        }
    }
}

- (void)addTrackpoints:(NSArray *)array
{
    for (GPXTrackPoint *trackpoint in array) {
        [self addTrackpoint:trackpoint];
    }
}

- (void)removeTrackpoint:(GPXTrackPoint *)trackpoint
{
    NSUInteger index = [_trackpoints indexOfObject:trackpoint];
    if (index != NSNotFound) {
        trackpoint.parent = nil;
        [_trackpoints removeObject:trackpoint];
    }
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"trkseg";
}


#pragma mark - GPX

- (void)addChildTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [super addChildTagToGpx:gpx indentationLevel:indentationLevel];
    
    if (self.extensions) {
        [self.extensions gpx:gpx indentationLevel:indentationLevel];
    }
    
    for (GPXTrackPoint *trackpoint in self.trackpoints) {
        [trackpoint gpx:gpx indentationLevel:indentationLevel];
    }
}

@end
