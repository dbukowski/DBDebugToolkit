//
//  GPXPointSegment.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXPointSegment.h"
#import "GPXElementSubclass.h"
#import "GPXPoint.h"

@implementation GPXPointSegment {
    NSMutableArray *_points;
}

@synthesize points = _points;

#pragma mark - Instance

- (id)init
{
    self = [super init];
    if (self) {
        _points = [NSMutableArray array];
    }
    return self;
}

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super initWithXMLElement:element parent:parent];
    if (self) {
        NSMutableArray *array1 = [NSMutableArray array];
        [self childElementsOfClass:[GPXPoint class]
                        xmlElement:element
                         eachBlock:^(GPXElement *element) {
                             [array1 addObject:element];
                         }];
        _points = array1;

    }
    return self;
}


#pragma mark - Public methods

- (GPXPoint *)newPointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXPoint *point = [GPXPoint pointWithLatitude:latitude longitude:longitude];
    [self addPoint:point];
    return point;
}

- (void)addPoint:(GPXPoint *)point
{
    if (point) {
        NSUInteger index = [_points indexOfObject:point];
        if (index == NSNotFound) {
            point.parent = self;
            [_points addObject:point];
        }
    }
}

- (void)addPoints:(NSArray *)array
{
    for (GPXPoint *point in array) {
        [self addPoint:point];
    }
}

- (void)removePoint:(GPXPoint *)point
{
    NSUInteger index = [_points indexOfObject:point];
    if (index != NSNotFound) {
        point.parent = nil;
        [_points removeObject:point];
    }
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"ptseg";
}


#pragma mark - GPX

- (void)addChildTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [super addChildTagToGpx:gpx indentationLevel:indentationLevel];
    
    for (GPXPoint *pont in self.points) {
        [pont gpx:gpx indentationLevel:indentationLevel];
    }
}

@end
