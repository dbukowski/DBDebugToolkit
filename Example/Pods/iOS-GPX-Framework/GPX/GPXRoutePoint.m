//
//  GPXRoutePoint.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXRoutePoint.h"

@implementation GPXRoutePoint


#pragma mark - Instance

+ (GPXRoutePoint *)routepointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    GPXRoutePoint *routepoint = [GPXRoutePoint new];
    routepoint.latitude = latitude;
    routepoint.longitude = longitude;
    return routepoint;
}


#pragma mark - tag

+ (NSString *)tagName
{
    return @"rtept";
}

@end
