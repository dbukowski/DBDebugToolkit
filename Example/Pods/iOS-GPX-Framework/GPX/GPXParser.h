//
//  GPXParser.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

@class GPXRoot;


/** Instances of this class parse GPX documents.
 */
@interface GPXParser : NSObject


/// ---------------------------------
/// @name Parsing
/// ---------------------------------

/** Parsing the GPX content referenced by the given URL.
 
 @param url An NSURL object specifying a URL. The URL must be fully qualified and refer to a scheme that is supported by the NSURL class.
 @return An initialized GPXRoot object or nil if an error occurs.
 */
+ (GPXRoot *)parseGPXAtURL:(NSURL *)url;

/** Parsing the GPX content referenced by the given File path.
 
 @param path The absolute path of the file from which to read GPX data.
 @return An initialized GPXRoot object or nil if an error occurs.
 */
+ (GPXRoot *)parseGPXAtPath:(NSString *)path;

/** Parsing the GPX content referenced by the given GPX string.
 
 @param string The GPX string.
 @return An initialized GPXRoot object or nil if an error occurs.
 */
+ (GPXRoot *)parseGPXWithString:(NSString*)string;

/** Parsing the GPX content referenced by the given data.
 
 @param data The data from which to read GPX data.
 @return An initialized GPXROot object or nil if an error occurs.
 */
+ (GPXRoot *)parseGPXWithData:(NSData*)data;

@end
