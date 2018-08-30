//
//  GPXTrackPoint.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXTrackPoint.h"

@implementation GPXTrackPoint


#pragma mark - Instance

+ (GPXTrackPoint *)trackpointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXTrackPoint *trackpoint = [GPXTrackPoint new];
    trackpoint.latitude = latitude;
    trackpoint.longitude = longitude;
    return trackpoint;
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"trkpt";
}

@end
