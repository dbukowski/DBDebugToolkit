//
//  GPXWaypoint.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"

@class GPXExtensions;
@class GPXLink;


/** wpt represents a waypoint, point of interest, or named feature on a map.
 */
@interface GPXWaypoint : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** Elevation (in meters) of the point. */
@property (nonatomic, assign) CGFloat elevation;

/** Creation/modification timestamp for element. 
    Date and time in are in Univeral Coordinated Time (UTC), not local time! 
    Conforms to ISO 8601 specification for date/time representation.
    Fractional seconds are allowed for millisecond timing in tracklogs */
@property (strong, nonatomic) NSDate *time;

/** Magnetic variation (in degrees) at the point */
@property (nonatomic, assign) CGFloat magneticVariation;

/** Height (in meters) of geoid (mean sea level) above WGS84 earth ellipsoid. As defined in NMEA GGA message. */
@property (nonatomic, assign) CGFloat geoidHeight;

/** The GPS name of the waypoint. This field will be transferred to and from the GPS. 
    GPX does not place restrictions on the length of this field or the characters contained in it. 
    It is up to the receiving application to validate the field before sending it to the GPS. */
@property (strong, nonatomic) NSString *name;

/** GPS waypoint comment. Sent to GPS as comment. */
@property (strong, nonatomic) NSString *comment;

/** A text description of the element. Holds additional information about the element intended for the user, not the GPS. */
@property (strong, nonatomic) NSString *desc;

/** Source of data. Included to give user some idea of reliability and accuracy of data. 
    "Garmin eTrex", "USGS quad Boston North", e.g. */
@property (strong, nonatomic) NSString *source;

/** Link to additional information about the waypoint. */
@property (strong, nonatomic) NSArray *links;

/** Text of GPS symbol name. For interchange with other programs, use the exact spelling of the symbol as displayed on the GPS. 
    If the GPS abbreviates words, spell them out. */
@property (strong, nonatomic) NSString *symbol;

/** Type (classification) of the waypoint. */
@property (strong, nonatomic) NSString *type;

/** Type of GPX fix. */
@property (nonatomic, assign) NSInteger fix;

/** Number of satellites used to calculate the GPX fix. */
@property (nonatomic, assign) NSInteger satellites;

/** Horizontal dilution of precision. */
@property (nonatomic, assign) CGFloat horizontalDilution;

/** Vertical dilution of precision. */
@property (nonatomic, assign) CGFloat verticalDilution;

/** Position dilution of precision. */
@property (nonatomic, assign) CGFloat positionDilution;

/** Number of seconds since last DGPS update. */
@property (nonatomic, assign) CGFloat ageOfDGPSData;

/** ID of DGPS station used in differential correction. */
@property (nonatomic, assign) NSInteger DGPSid;

/** You can add extend GPX by adding your own elements from another schema here. */
@property (strong, nonatomic) GPXExtensions *extensions;

/** The latitude of the point. Decimal degrees, WGS84 datum. */
@property (nonatomic, assign) CGFloat latitude;

/** The longitude of the point. Decimal degrees, WGS84 datum. */
@property (nonatomic, assign) CGFloat longitude;


/// ---------------------------------
/// @name Create Waypoint
/// ---------------------------------

/** Creates and returns a new waypoint element.
 @param latitude The latitude of the point.
 @param longitude The longitude of the point.
 @return A newly created waypoint element.
 */
+ (GPXWaypoint *)waypointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;


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
/// @name Removing Link
/// ---------------------------------

/** Removes all occurrences in the link array of a given GPXLink object.
 @param link The GPXLink object to remove from the link array.
 */
- (void)removeLink:(GPXLink *)link;

@end
