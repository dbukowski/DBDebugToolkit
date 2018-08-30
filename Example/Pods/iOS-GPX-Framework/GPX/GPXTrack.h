//
//  GPXTrack.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"

@class GPXExtensions;
@class GPXLink;
@class GPXTrackSegment;
@class GPXTrackPoint;


/** trk represents a track - an ordered list of points describing a path.
 */
@interface GPXTrack : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** GPS name of track. */
@property (strong, nonatomic) NSString *name;

/** GPS comment for track. */
@property (strong, nonatomic) NSString *comment;

/** User description of track. */
@property (strong, nonatomic) NSString *desc;

/** Source of data. Included to give user some idea of reliability and accuracy of data. */
@property (strong, nonatomic) NSString *source;

/** Links to external information about track. */
@property (strong, nonatomic, readonly) NSArray *links;

/** GPS track number. */
@property (nonatomic, assign) NSInteger number;

/** Type (classification) of track. */
@property (strong, nonatomic) NSString *type;

/** You can add extend GPX by adding your own elements from another schema here. */
@property (strong, nonatomic) GPXExtensions *extensions;

/** A Track Segment holds a list of Track Points which are logically connected in order.
    To represent a single GPS track where GPS reception was lost, or the GPS receiver was turned off, 
    start a new Track Segment for each continuous span of track data. */
@property (strong, nonatomic, readonly) NSArray *tracksegments;


/// ---------------------------------
/// @name Creating Link
/// ---------------------------------

/** Creates and returns a new link element.
 @param href URL of hyperlink
 @return A newly created link element.
 */
- (GPXLink *)newLinkWithHref:(NSString *)href;


/// ---------------------------------
/// @name Adding Link
/// ---------------------------------

/** Inserts a given GPXLink object at the end of the link array.
 @param link The GPXLink to add to the end of the link array.
 */
- (void)addLink:(GPXLink *)link;

/** Adds the GPXLink objects contained in another given array to the end of the link array.
 @param array An array of GPXLink objects to add to the end of the link array.
 */
- (void)addLinks:(NSArray *)array;


/// ---------------------------------
/// @name Adding Link
/// ---------------------------------

/** Removes all occurrences in the link array of a given GPXLink object.
 @param link The GPXLink object to remove from the link array.
 */
- (void)removeLink:(GPXLink *)link;


/// ---------------------------------
/// @name Creating Tracksegment
/// ---------------------------------

/** Creates and returns a new tracksegment element.
 @return A newly created tracksegment element.
 */
- (GPXTrackSegment *)newTrackSegment;


/// ---------------------------------
/// @name Adding Tracksegment
/// ---------------------------------

/** Inserts a given GPXTrackSegment object at the end of the tracksegment array.
 @param tracksegment The GPXTrackSegment to add to the end of the tracksegment array.
 */
- (void)addTracksegment:(GPXTrackSegment *)tracksegment;

/** Adds the GPXTrackSegment objects contained in another given array to the end of the tracksegment array.
 @param array An array of GPXTrackSegment objects to add to the end of the tracksegment array.
 */
- (void)addTracksegments:(NSArray *)array;


/// ---------------------------------
/// @name Adding Tracksegment
/// ---------------------------------

/** Removes all occurrences in the tracksegment array of a given GPXTrackSegment object.
 @param tracksegment The GPXTrackSegment object to remove from the tracksegment array.
 */
- (void)removeTracksegment:(GPXTrackSegment *)tracksegment;


/// ---------------------------------
/// @name Creating Trackpoint
/// ---------------------------------

/** Creates and returns a new trackpoint element.
 @param latitude The latitude of the point.
 @param longitude The longitude of the point.
 @return A newly created trackpoint element.
 */
- (GPXTrackPoint *)newTrackpointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end
