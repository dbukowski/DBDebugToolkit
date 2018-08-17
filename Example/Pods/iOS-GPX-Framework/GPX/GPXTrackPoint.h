//
//  GPXTrackPoint.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXWaypoint.h"

@interface GPXTrackPoint : GPXWaypoint

/// ---------------------------------
/// @name Create Trackpoint
/// ---------------------------------

/** Creates and returns a new trackpoint element.
 @param latitude The latitude of the point.
 @param longitude The longitude of the point.
 @return A newly created trackpoint element.
 */
+ (GPXTrackPoint *)trackpointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end
