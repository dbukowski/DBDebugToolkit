//
//  GPXPointSegment.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"

@class GPXPoint;


/** An ordered sequence of points. (for polygons or polylines, e.g.)
 */
@interface GPXPointSegment : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** Ordered list of geographic points. */
@property (strong, nonatomic, readonly) NSArray *points;


/// ---------------------------------
/// @name Creating Point
/// ---------------------------------

/** Creates and returns a new point element.
 @param latitude The latitude of the point.
 @param longitude The longitude of the point.
 @return A newly created point element.
 */
- (GPXPoint *)newPointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;


/// ---------------------------------
/// @name Adding Point
/// ---------------------------------

/** Inserts a given GPXPoint object at the end of the point array.
 @param point The GPXPoint to add to the end of the point array.
 */
- (void)addPoint:(GPXPoint *)point;

/** Adds the GPXPoint objects contained in another given array to the end of the point array.
 @param array An array of GPXPoint objects to add to the end of the point array.
 */
- (void)addPoints:(NSArray *)array;


/// ---------------------------------
/// @name Removing Point
/// ---------------------------------

/** Removes all occurrences in the point array of a given GPXPoint object.
 @param point The GPXPoint object to remove from the point array.
 */
- (void)removePoint:(GPXPoint *)point;

@end
