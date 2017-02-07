//
//  CLLocationManager+DBLocationToolkit.m
//  Pods
//
//  Created by Dariusz Bukowski on 07.02.2017.
//
//

#import "CLLocationManager+DBLocationToolkit.h"
#import "DBLocationToolkit.h"
#import "NSObject+DBDebugToolkit.h"
#import <objc/runtime.h>

static NSString *const CLLocationManagerLocationsKey = @"Locations";

@implementation CLLocationManager (DBLocationToolkit)

+ (void)load {
    [self exchangeInstanceMethodsWithOriginalSelector:NSSelectorFromString(@"onClientEventLocation:")
                                  andSwizzledSelector:@selector(db_onClientEventLocation:)];
    [self exchangeInstanceMethodsWithOriginalSelector:NSSelectorFromString(@"onClientEventLocation:forceMapMatching:type:")
                                  andSwizzledSelector:@selector(db_onClientEventLocation:forceMapMatching:type:)];
}

- (void)db_onClientEventLocation:(NSDictionary *)dictionary {
    if ([DBLocationToolkit sharedInstance].simulatedLocation == nil) {
        [self db_onClientEventLocation:dictionary];
    } else {
        [self.delegate locationManager:self didUpdateLocations:@[[DBLocationToolkit sharedInstance].simulatedLocation]];
    }
}

- (void)db_onClientEventLocation:(NSDictionary *)dictionary forceMapMatching:(BOOL)forceMapMatching type:(id)type {
    if ([DBLocationToolkit sharedInstance].simulatedLocation == nil) {
        [self db_onClientEventLocation:dictionary forceMapMatching:forceMapMatching type:type];
    } else {
        [self.delegate locationManager:self didUpdateLocations:@[[DBLocationToolkit sharedInstance].simulatedLocation]];
    }
}

@end
