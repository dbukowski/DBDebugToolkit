//
//  GPXTrack.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXTrack.h"
#import "GPXElementSubclass.h"
#import "GPXLink.h"
#import "GPXExtensions.h"
#import "GPXTrackSegment.h"
#import "GPXTrackPoint.h"

@implementation GPXTrack {
    NSMutableArray *_links;
    NSMutableArray *_tracksegments;
    NSString *_numberValue;
}

@synthesize name = _name;
@synthesize comment = _comment;
@synthesize desc = _desc;
@synthesize source = _source;
@synthesize links = _links;
@synthesize number = _number;
@synthesize type = _type;
@synthesize extensions = _extensions;
@synthesize tracksegments = _tracksegments;


#pragma mark - Instance

- (id)init
{
    self = [super init];
    if (self) {
        _links = [NSMutableArray array];
        _tracksegments = [NSMutableArray array];
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
        [self childElementsOfClass:[GPXTrackSegment class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array2 addObject:element];
                         }];
        _tracksegments = array2;
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

- (GPXTrackSegment *)newTrackSegment
{
    GPXTrackSegment *tracksegment = [GPXTrackSegment new];
    [self addTracksegment:tracksegment];
    return tracksegment;
}

- (void)addTracksegment:(GPXTrackSegment *)tracksegment
{
    if (tracksegment) {
        NSUInteger index = [_tracksegments indexOfObject:tracksegment];
        if (index == NSNotFound) {
            tracksegment.parent = self;
            [_tracksegments addObject:tracksegment];
        }
    }
}

- (void)addTracksegments:(NSArray *)array
{
    for (GPXTrackSegment *tracksegment in array) {
        [self addTracksegment:tracksegment];
    }
}

- (void)removeTracksegment:(GPXTrackSegment *)tracksegment
{
    NSUInteger index = [_tracksegments indexOfObject:tracksegment];
    if (index != NSNotFound) {
        tracksegment.parent = nil;
        [_tracksegments removeObject:tracksegment];
    }
}

- (GPXTrackPoint *)newTrackpointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXTrackSegment *tracksegment;

    // create a new segment if needed
    if (_tracksegments.count == 0) {
        [self newTrackSegment];
    }

    // get latest segment
    tracksegment = [_tracksegments lastObject];

    return [tracksegment newTrackpointWithLatitude:latitude longitude:longitude];
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"trk";
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
    
    for (GPXTrackSegment *tracksegment in self.tracksegments) {
        [tracksegment gpx:gpx indentationLevel:indentationLevel];
    }
}

@end
