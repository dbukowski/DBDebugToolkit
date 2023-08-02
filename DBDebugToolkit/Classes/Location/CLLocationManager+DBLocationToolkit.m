// The MIT License
//
// Copyright (c) 2016 Dariusz Bukowski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "CLLocationManager+DBLocationToolkit.h"
#import "DBLocationToolkit.h"
#import "NSObject+DBDebugToolkit.h"
#import <objc/runtime.h>

static NSString *const CLLocationManagerLocationsKey = @"Locations";

@implementation CLLocationManager (DBLocationToolkit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Making sure to minimize the risk of rejecting app because of the private API.
        NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x6f, 0x6e, 0x43, 0x6c, 0x69, 0x65, 0x6e, 0x74, 0x45, 0x76, 0x65, 0x6e, 0x74, 0x4c, 0x6f, 0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x3a} length:22] encoding:NSASCIIStringEncoding];
        [self exchangeInstanceMethodsWithOriginalSelector:NSSelectorFromString(key)
                                      andSwizzledSelector:@selector(db_onClientEventLocation:)];
        // Making sure to minimize the risk of rejecting app because of the private API.
        key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x6f, 0x6e, 0x43, 0x6c, 0x69, 0x65, 0x6e, 0x74, 0x45, 0x76, 0x65, 0x6e, 0x74, 0x4c, 0x6f, 0x63, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x3a, 0x66, 0x6f, 0x72, 0x63, 0x65, 0x4d, 0x61, 0x70, 0x4d, 0x61, 0x74, 0x63, 0x68, 0x69, 0x6e, 0x67, 0x3a, 0x74, 0x79, 0x70, 0x65, 0x3a} length:44] encoding:NSASCIIStringEncoding];
        [self exchangeInstanceMethodsWithOriginalSelector:NSSelectorFromString(key)
                                      andSwizzledSelector:@selector(db_onClientEventLocation:forceMapMatching:type:)];
    });
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
