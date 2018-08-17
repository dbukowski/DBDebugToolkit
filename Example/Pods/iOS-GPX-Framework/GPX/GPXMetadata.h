//
//  GPXMetadata.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"

@class GPXAuthor;
@class GPXCopyright;
@class GPXLink;
@class GPXBounds;
@class GPXExtensions;


/** Information about the GPX file, author, and copyright restrictions goes in the metadata section. 
    Providing rich, meaningful information about your GPX files allows others to search for and use your GPS data.
 */
@interface GPXMetadata : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** The name of the GPX file. */
@property (strong, nonatomic) NSString *name;

/** A description of the contents of the GPX file. */
@property (strong, nonatomic) NSString *desc;

/** The person or organization who created the GPX file. */
@property (strong, nonatomic) GPXAuthor *author;

/** Copyright and license information governing use of the file. */
@property (strong, nonatomic) GPXCopyright *copyright;

/** URLs associated with the location described in the file. */
@property (strong, nonatomic) GPXLink *link;

/** The creation date of the file. */
@property (strong, nonatomic) NSDate *time;

/** Keywords associated with the file. Search engines or databases can use this information to classify the data. */
@property (strong, nonatomic) NSString *keyword;

/** Minimum and maximum coordinates which describe the extent of the coordinates in the file. */
@property (strong, nonatomic) GPXBounds *bounds;

/** You can add extend GPX by adding your own elements from another schema here. */
@property (strong, nonatomic) GPXExtensions *extensions;

@end
