//
//  GPXRoutePoint.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXWaypoint.h"

@interface GPXRoutePoint : GPXWaypoint

/// ---------------------------------
/// @name Create RoutePoint
/// ---------------------------------

/** Creates and returns a new routepoint element.
 @param latitude The latitude of the point.
 @param longitude The longitude of the point.
 @return A newly created routepoint element.
 */
+ (GPXRoutePoint *)routepointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end
