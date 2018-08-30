//
//  GPXElementSubclass.h
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"
#import "TBXML.h"

@interface GPXElement ()

// Tag

+ (NSString *)tagName;
+ (NSArray *)implementClasses;


// Initializing a Element

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent;


// Parsing
- (NSString *)valueOfAttributeNamed:(NSString *)name xmlElement:(TBXMLElement*)element;
- (NSString *)valueOfAttributeNamed:(NSString *)name xmlElement:(TBXMLElement*)element required:(BOOL)required;
- (NSString *)textForSingleChildElementNamed:(NSString *)name xmlElement:(TBXMLElement *)element;
- (NSString *)textForSingleChildElementNamed:(NSString *)name xmlElement:(TBXMLElement *)element required:(BOOL)required;
- (GPXElement *)childElementOfClass:(Class)class xmlElement:(TBXMLElement *)element;
- (GPXElement *)childElementOfClass:(Class)class xmlElement:(TBXMLElement *)element required:(BOOL)required;
- (GPXElement *)childElementNamed:(NSString *)name class:(Class)class xmlElement:(TBXMLElement *)element;
- (GPXElement *)childElementNamed:(NSString *)name class:(Class)class xmlElement:(TBXMLElement *)element required:(BOOL)required;
- (void)childElementsOfClass:(Class)class xmlElement:(TBXMLElement *)element eachBlock:(void (^)(GPXElement *element))eachBlock;


// Generating

- (void)gpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel;
- (void)addOpenTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel;
- (void)addChildTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel;
- (void)addCloseTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel;

- (void)gpx:(NSMutableString *)gpx addPropertyForValue:(NSString *)value tagName:(NSString *)tagName indentationLevel:(NSInteger)indentationLevel;
- (void)gpx:(NSMutableString *)gpx addPropertyForValue:(NSString *)value tagName:(NSString *)tagName attribute:(NSString *)attribute indentationLevel:(NSInteger)indentationLevel;
- (void)gpx:(NSMutableString *)gpx addPropertyForValue:(NSString *)value defaultValue:(NSString *)defaultValue tagName:(NSString *)tagName indentationLevel:(NSInteger)indentationLevel;
- (void)gpx:(NSMutableString *)gpx addPropertyForValue:(NSString *)value defaultValue:(NSString *)defaultValue tagName:(NSString *)tagName attribute:(NSString *)attribute indentationLevel:(NSInteger)indentationLevel;
- (NSString *)indentForIndentationLevel:(NSInteger)indentationLevel;

@end
