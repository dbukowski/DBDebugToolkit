//
//  GPXElement.m
//  GPX Framework
//
//  Created by NextBusinessSystem on 12/04/06.
//  Copyright (c) 2012 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import "GPXElement.h"
#import "GPXConst.h"
#import "GPXElementSubclass.h"


@implementation GPXElement

@synthesize parent = _parent;


#pragma mark - Tag

+ (NSString *)tagName
{
    return nil;
}

+ (NSArray *)implementClasses
{
    return nil;
}


#pragma mark - Instance

- (id)initWithXMLElement:(TBXMLElement *)element parent:(GPXElement *)parent
{
    self = [super init];
    if (self) {
        self.parent = parent;
    }
    return self;
}

- (void)dealloc
{
    _parent = nil;
}


#pragma mark - Elements

- (NSString *)valueOfAttributeNamed:(NSString *)name xmlElement:(TBXMLElement*)element
{
    return [self valueOfAttributeNamed:name xmlElement:element required:NO];
}

- (NSString *)valueOfAttributeNamed:(NSString *)name xmlElement:(TBXMLElement*)element required:(BOOL)required
{
    NSString *value = [TBXML valueOfAttributeNamed:name forElement:element];
    
    if (!value && required) {
        NSString *description = [NSString stringWithFormat:@"%@ element require %@ attribute.", [[self class] tagName], name];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGPXInvalidGPXFormatNotification
                                                            object:self
                                                          userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, kGPXDescriptionKey, nil]];
    }
    return value;
}


- (NSString *)textForSingleChildElementNamed:(NSString *)name xmlElement:(TBXMLElement *)element
{
    return [self textForSingleChildElementNamed:name xmlElement:element required:NO];
}

- (NSString *)textForSingleChildElementNamed:(NSString *)name xmlElement:(TBXMLElement *)element required:(BOOL)required
{
    TBXMLElement *el = [TBXML childElementNamed:name parentElement:element];
    if (el) {
        return [TBXML textForElement:el];
    } else {
        if (required) {
            NSString *description = [NSString stringWithFormat:@"%@ element require %@ element.", [[self class] tagName], name];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGPXInvalidGPXFormatNotification
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, kGPXDescriptionKey, nil]];
        }
    }
    
    return nil;
}

- (GPXElement *)childElementOfClass:(Class)class xmlElement:(TBXMLElement *)element
{
    return [self childElementOfClass:class xmlElement:element required:NO];
}

- (GPXElement *)childElementOfClass:(Class)class xmlElement:(TBXMLElement *)element required:(BOOL)required
{
    GPXElement *firstElement;
    TBXMLElement *el = [TBXML childElementNamed:[class tagName] parentElement:element];
    if (el) {
        firstElement = [[class alloc] initWithXMLElement:el parent:self];
        
        TBXMLElement *secondElement = [TBXML nextSiblingNamed:[class tagName] searchFromElement:el];
        if (secondElement) {
            NSString *description = [NSString stringWithFormat:@"%@ element has more than two %@ elements.", [[self class] tagName], [class tagName]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGPXInvalidGPXFormatNotification
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, kGPXDescriptionKey, nil]];
        }
    }
    
    if (required) {
        if (!firstElement) {
            NSString *description = [NSString stringWithFormat:@"%@ element require %@ element.", [[self class] tagName], [class tagName]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGPXInvalidGPXFormatNotification
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, kGPXDescriptionKey, nil]];
        }
    }
    
    return firstElement;
}

- (GPXElement *)childElementNamed:(NSString *)name class:(Class)class xmlElement:(TBXMLElement *)element
{
    return [self childElementNamed:name class:class xmlElement:element required:NO];
}

- (GPXElement *)childElementNamed:(NSString *)name class:(Class)class xmlElement:(TBXMLElement *)element required:(BOOL)required
{
    GPXElement *firstElement;
    TBXMLElement *el = [TBXML childElementNamed:name parentElement:element];
    if (el) {
        firstElement = [[class alloc] initWithXMLElement:el parent:self];
        
        TBXMLElement *secondElement = [TBXML nextSiblingNamed:name searchFromElement:el];
        if (secondElement) {
            NSString *description = [NSString stringWithFormat:@"%@ element has more than two %@ elements.", [[self class] tagName], [class tagName]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGPXInvalidGPXFormatNotification
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, kGPXDescriptionKey, nil]];
        }
    }
    
    if (required) {
        if (!firstElement) {
            NSString *description = [NSString stringWithFormat:@"%@ element require %@ element.", [[self class] tagName], [class tagName]];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kGPXInvalidGPXFormatNotification
                                                                object:self
                                                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:description, kGPXDescriptionKey, nil]];
        }
    }
    
    return firstElement;
}

- (void)childElementsOfClass:(Class)class xmlElement:(TBXMLElement *)element eachBlock:(void (^)(GPXElement *element))eachBlock
{
    TBXMLElement *el = [TBXML childElementNamed:[class tagName] parentElement:element];
    while (el != nil) {
        eachBlock([[class alloc] initWithXMLElement:el parent:self]);
        el = [TBXML nextSiblingNamed:[class tagName] searchFromElement:el];
    }
}


#pragma mark - GPX

- (NSString *)gpx {
    NSMutableString *gpx = [NSMutableString stringWithString:@""];
    [self gpx:gpx indentationLevel:0];
    return gpx;
}

- (void)gpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [self addOpenTagToGpx:gpx indentationLevel:indentationLevel];
    [self addChildTagToGpx:gpx indentationLevel:indentationLevel + 1];
    [self addCloseTagToGpx:gpx indentationLevel:indentationLevel];
}

- (void)addOpenTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [gpx appendString:[NSString stringWithFormat:@"%@<%@>\r\n"
                       , [self indentForIndentationLevel:indentationLevel]
                       , [[self class] tagName]
                       ]
     ];
}

- (void)addChildTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    // Override to subclasses
}

- (void)addCloseTagToGpx:(NSMutableString *)gpx indentationLevel:(NSInteger)indentationLevel
{
    [gpx appendString:[NSString stringWithFormat:@"%@</%@>\r\n"
                       , [self indentForIndentationLevel:indentationLevel]
                       , [[self class] tagName]
                       ]
     ];
}

- (void)gpx:(NSMutableString *)gpx addPropertyForValue:(NSString *)value tagName:(NSString *)tagName indentationLevel:(NSInteger)indentationLevel
{
    [self gpx:gpx addPropertyForValue:value defaultValue:nil tagName:tagName attribute:nil indentationLevel:indentationLevel];
}

- (void)gpx:(NSMutableString *)gpx addPropertyForValue:(NSString *)value tagName:(NSString *)tagName attribute:(NSString *)attribute indentationLevel:(NSInteger)indentationLevel
{
    [self gpx:gpx addPropertyForValue:value defaultValue:nil tagName:tagName attribute:attribute indentationLevel:indentationLevel];
}

- (void)gpx:(NSMutableString *)gpx addPropertyForValue:(NSString *)value defaultValue:(NSString *)defaultValue tagName:(NSString *)tagName indentationLevel:(NSInteger)indentationLevel
{
    [self gpx:gpx addPropertyForValue:value defaultValue:defaultValue tagName:tagName attribute:nil indentationLevel:indentationLevel];
}

- (void)gpx:(NSMutableString *)gpx addPropertyForValue:(NSString *)value defaultValue:(NSString *)defaultValue tagName:(NSString *)tagName attribute:(NSString *)attribute indentationLevel:(NSInteger)indentationLevel;
{
    if (!value || [value isEqualToString:@""]) {
        return;
    }
    
    if (defaultValue && [value isEqualToString:defaultValue]) {
        return;
    }
    
    BOOL outputCDMA = NO;
    NSRange match = [value rangeOfString:@"[^a-zA-Z0-9.,+-/*!='\"()\\[\\]{}!$%@?_;: #\t\r\n]" options:NSRegularExpressionSearch];
    if (match.location != NSNotFound) {
        outputCDMA = YES;
    }
    
    if (outputCDMA) {
        [gpx appendString:[NSString stringWithFormat:@"%@<%@%@><![CDATA[%@]]></%@>\r\n"
                           , [self indentForIndentationLevel:indentationLevel]
                           , tagName
                           , attribute ? [@" " stringByAppendingString:attribute]: @""
                           , [value stringByReplacingOccurrencesOfString:@"]]>" withString:@"]]&gt;"]
                           , tagName]
         ];
    } else {
        [gpx appendString:[NSString stringWithFormat:@"%@<%@%@>%@</%@>\r\n"
                           , [self indentForIndentationLevel:indentationLevel]
                           , tagName
                           , attribute ? [@" " stringByAppendingString:attribute]: @""
                           , value
                           , tagName]
         ];
    }
}

- (NSString *)indentForIndentationLevel:(NSInteger)indentationLevel
{
    NSMutableString *result = [NSMutableString string];
    
    for (int i = 0; i < indentationLevel; ++i) {
        [result appendString:@"\t"];
    }
    
    return result;
}

@end
