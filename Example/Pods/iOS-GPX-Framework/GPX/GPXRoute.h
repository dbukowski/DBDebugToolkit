//
//  GPXRoute.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"

@class GPXLink;
@class GPXExtensions;
@class GPXRoutePoint;


/** rte represents route - an ordered list of waypoints representing a series of turn points leading to a destination.
 */
@interface GPXRoute : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** GPS name of route. */
@property (strong, nonatomic) NSString *name;

/** GPS comment for route. */
@property (strong, nonatomic) NSString *comment;

/** Text description of route for user. Not sent to GPS. */
@property (strong, nonatomic) NSString *desc;

/** Source of data. Included to give user some idea of reliability and accuracy of data. */
@property (strong, nonatomic) NSString *source;

/** Links to external information about the route. */
@property (strong, nonatomic, readonly) NSArray *links;

/** GPS route number. */
@property (nonatomic, assign) NSInteger number;

/** Type (classification) of route. */
@property (strong, nonatomic) NSString *type;

/** You can add extend GPX by adding your own elements from another schema here. */
@property (strong, nonatomic) GPXExtensions *extensions;

/** A list of route points. */
@property (strong, nonatomic, readonly) NSArray *routepoints;


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


/// ---------------------------------
/// @name Creating Routepoint
/// ---------------------------------

/** Creates and returns a new routepoint element.
 @param latitude The latitude of the point.
 @param longitude The longitude of the point.
 @return A newly created routepoint element.
 */
- (GPXRoutePoint *)newRoutepointWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;


/// ---------------------------------
/// @name Adding Routepoint
/// ---------------------------------

/** Inserts a given GPXRoutePoint object at the end of the routepoint array.
 @param routepoint The GPXRoutePoint to add to the end of the routepoint array.
 */
- (void)addRoutepoint:(GPXRoutePoint *)routepoint;

/** Adds the GPXRoutePoint objects contained in another given array to the end of the routepoint array.
 @param array An array of GPXRoutePoint objects to add to the end of the routepoint array.
 */
- (void)addRoutepoints:(NSArray *)array;


/// ---------------------------------
/// @name Removing Routepoint
/// ---------------------------------

/** Removes all occurrences in the routepoint array of a given GPXRoutePoint object.
 @param routepoint The GPXRoutePoint object to remove from the routepoint array.
 */
- (void)removeRoutepoint:(GPXRoutePoint *)routepoint;

@end
