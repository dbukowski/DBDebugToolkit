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

#import "DBLocationToolkit.h"
#import "DBDebugToolkitUserDefaultsKeys.h"
#import "GPX.h"

@interface DBLocationToolkit ()
{
    NSMutableArray *locationArrayOthers;
}

@property (nonatomic, strong) NSArray <NSMutableArray<DBPresetLocation *> *> *presetLocations;

@end

@implementation DBLocationToolkit

@synthesize simulatedLocation;

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static DBLocationToolkit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBLocationToolkit alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Simulated location

- (void)setSimulatedLocation:(NSMutableArray *)aSimulatedLocation {
    if (aSimulatedLocation != simulatedLocation) {
        simulatedLocation = aSimulatedLocation;
        if (simulatedLocation) {
            NSMutableArray *archivedLocations = [[NSMutableArray alloc] init];
            [simulatedLocation enumerateObjectsUsingBlock:^(DBPresetLocation  *location, NSUInteger idx, BOOL * _Nonnull stop) {
                [archivedLocations addObject:[NSKeyedArchiver archivedDataWithRootObject:location]];
            }];
            [[NSUserDefaults standardUserDefaults] setObject:archivedLocations
                                                      forKey:DBDebugToolkitUserDefaultsSimulatedLocations];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:DBDebugToolkitUserDefaultsSimulatedLocations];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSMutableArray<DBPresetLocation *> *)simulatedLocation {
    if (!simulatedLocation) {
        NSMutableArray *locations = [[NSUserDefaults standardUserDefaults] objectForKey:DBDebugToolkitUserDefaultsSimulatedLocations];
        if (locations != nil) {
            NSMutableArray *dbPresetLocations = [[NSMutableArray alloc] init];
            [locations enumerateObjectsUsingBlock:^(NSData  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DBPresetLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                [dbPresetLocations addObject:location];
            }];
            return dbPresetLocations;
        }
    }
    
    return simulatedLocation;
}

#pragma mark - Preset locations

- (NSArray <NSMutableArray<DBPresetLocation *> *> *)presetLocations {
    if (!_presetLocations) {
        NSMutableArray *presetLocations = [NSMutableArray array];
        [NSBundle.mainBundle URLForResource:@"Trip" withExtension:@"gpx"];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"London, England"
                                      latitude:51.509980
                                      longitude:-0.133700]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Johannesburg, South Africa"
                                                                    latitude:-26.204103
                                                                   longitude:28.047305]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Moscow, Russia"
                                                                    latitude:55.755786
                                                                   longitude:37.617633]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Mumbai, India"
                                                                    latitude:19.017615
                                                                   longitude:72.856164]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Tokyo, Japan"
                                                                    latitude:35.702069
                                                                   longitude:139.775327]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Sydney, Australia"
                                                                    latitude:-33.863400
                                                                   longitude:151.211000]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Hong Kong, China"
                                                                    latitude:22.284681
                                                                   longitude:114.158177]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Honolulu, HI, USA"
                                                                    latitude:21.282778
                                                                   longitude:-157.829444]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"San Francisco, CA, USA"
                                                                    latitude:37.787359
                                                                   longitude:-122.408227]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Mexico City, Mexico"
                                                                    latitude:19.435478
                                                                   longitude:-99.136479]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"New York, NY, USA"
                                                                    latitude:40.759211
                                                                   longitude:-73.984638]]];
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Rio de Janeiro, Brazil"
                                                                    latitude:-22.903539
                                                                   longitude:-43.209587]]];
        
        [presetLocations addObject:@[[DBPresetLocation presetLocationWithTitle:@"Adelaide, Australia"
                                                                      latitude:-35.086572
                                                                     longitude:138.321284]]];
        
        
        // GPX parsing of Trip.gpx
        NSMutableArray *locationsArrayTrip =  [NSMutableArray new];
        NSString *str=[[NSBundle mainBundle] pathForResource:@"Trip" ofType:@"gpx"];
        NSData *fileData = [NSData dataWithContentsOfFile:str];
        GPXRoot *gpx = [GPXParser parseGPXWithData:fileData];
        NSArray *arrayLocations = [NSArray new];
        arrayLocations = [gpx waypoints];
        for (GPXWaypoint *point in arrayLocations){
            DBPresetLocation *location = [DBPresetLocation  presetLocationWithTitle:point.name latitude:point.latitude longitude:point.longitude];
            [locationsArrayTrip addObject:location];
        }
        //Added the gpx parsed array object in the presetlocations array
            [presetLocations addObject:locationsArrayTrip];

       
       _presetLocations = [presetLocations copy];
    }
    
    return _presetLocations;
}

@end
