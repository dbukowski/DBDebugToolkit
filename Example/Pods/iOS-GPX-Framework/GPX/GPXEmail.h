//
//  GPXEmail.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"


/** An email address. Broken into two parts (id and domain) to help prevent email harvesting.
 */
@interface GPXEmail : GPXElement


/// ---------------------------------
/// @name Accessing Properties
/// ---------------------------------

/** id half of email address (billgates2004) */
@property (strong, nonatomic) NSString *emailID;

/** domain half of email address (hotmail.com) */
@property (strong, nonatomic) NSString *domain;


/// ---------------------------------
/// @name Create Email
/// ---------------------------------

/** Creates and returns a new email element.
 @param id half of email address (billgates2004)
 @param domain half of email address (hotmail.com)
 @return A newly created email element.
 */
+ (GPXEmail *)emailWithID:(NSString *)emailID domain:(NSString *)domain;

@end
