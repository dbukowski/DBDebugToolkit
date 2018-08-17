//
//  GPXTrackSegment.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"

@class GPXExtensions;
@class GPXTrackPoint;


/** A Track Segment holds a list of Track Points which are logically connected in order. 
    To represent a single GPS track where GPS reception was lost, or the GPS receiver was turned off, start a new Track Segment for each continuous span of track data.
 */
@interface GPXTrackSegment : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** A Track Point holds the coordinates, elevation, timestamp, and metadata for a single point in a track. */
@property (strong, nonatomic, readonly) NSArray *trackpoints;

/** You can add extend GPX by adding your own elements from another schema here. */
@property (strong, nonatomic) GPXExtensions *extensions;


/// ---------------------------------
/// @name Creating Trackpoint
/// ---------------------------------

/** Creates and returns a new trackpoint element.
 @param latitude The latitude of the point.
 @param longitude The longitude of the point.
 @return A newly created trackpoint element.
 */
- (GPXTrackPoint *)newTrackpointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;


/// ---------------------------------
/// @name Adding Trackpoint
/// ---------------------------------

/** Inserts a given GPXTrackPoint object at the end of the trackpoint array.
 @param trackpoint The GPXTrackPoint to add to the end of the trackpoint array.
 */
- (void)addTrackpoint:(GPXTrackPoint *)trackpoint;

/** Adds the GPXTrackPoint objects contained in another given array to the end of the trackpoint array.
 @param array An array of GPXTrackPoint objects to add to the end of the trackpoint array.
 */
- (void)addTrackpoints:(NSArray *)array;


/// ---------------------------------
/// @name Adding Trackpoint
/// ---------------------------------

/** Removes all occurrences in the trackpoint array of a given GPXTrackPoint object.
 @param trackpoint The GPXTrackPoint object to remove from the trackpoint array.
 */
- (void)removeTrackpoint:(GPXTrackPoint *)trackpoint;

@end
