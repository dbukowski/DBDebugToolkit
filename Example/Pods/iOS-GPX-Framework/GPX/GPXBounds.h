//
//  GPXBounds.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"


/** Two lat/lon pairs defining the extent of an element.
 */
@interface GPXBounds : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** The minimum latitude. */
@property (nonatomic, assign) CGFloat minLatitude;

/** The minimum longitude. */
@property (nonatomic, assign) CGFloat minLongitude;

/** The maximum latitude. */
@property (nonatomic, assign) CGFloat maxLatitude;

/** The maximum longitude. */
@property (nonatomic, assign) CGFloat maxLongitude;


/// ---------------------------------
/// @name Create Bounds
/// ---------------------------------

/** Creates and returns a new bounds element.
 @param minLatitude The minimum latitude.
 @param minLongitude The minimum longitude.
 @param maxLatitude The maximum latitude.
 @param maxLongitude The maximum longitude.
 @return A newly created bounds element.
 */
+ (GPXBounds *)boundsWithMinLatitude:(CGFloat)minLatitude minLongitude:(CGFloat)minLongitude maxLatitude:(CGFloat)maxLatitude maxLongitude:(CGFloat)maxLongitude;

@end
