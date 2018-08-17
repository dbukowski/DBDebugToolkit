//
//  DBLocationExampleViewController.m
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 06.02.2017.
//  Copyright © 2017 Dariusz Bukowski. All rights reserved.
//

#import "DBLocationExampleViewController.h"
#import <MapKit/MapKit.h>

@interface DBLocationExampleViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

{
    NSMutableArray *latArray, *longArray;
    CLLocationCoordinate2D location;

}

@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) CLLocationManager *locationManager;



@end

@implementation DBLocationExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self setupLocationManager];
}

- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark *placemark = placemarks.firstObject;
                       NSMutableArray *placemarkDescriptions = [NSMutableArray array];
                       if (placemark.country) {
                           [placemarkDescriptions addObject:placemark.country];
                       }
                       if (placemark.administrativeArea) {
                           [placemarkDescriptions addObject:placemark.administrativeArea];
                       }
                       if (placemark.locality) {
                           [placemarkDescriptions addObject:placemark.locality];
                       }
                       self.label.text = [placemarkDescriptions componentsJoinedByString:@", "];
                   }];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
//   for (int i = 0; i<latArray.count; i++) {

//        location.latitude = [[latArray objectAtIndex:i] floatValue];
//        location.longitude = [[longArray objectAtIndex:i] floatValue];
//        float lat, longe;
//        lat = [[latArray objectAtIndex:i] floatValue];
//        longe = [[longArray objectAtIndex:i] floatValue];
//        CLLocationDegrees latDegree, longDegree;
//        latDegree = lat;
//        longDegree = longe;
//        MKUserLocation *lo =[MKUserLocation new];
//        lo.coordinate = CLLocationCoordinate2DMake(latDegree,longDegree);
//        CLLocationCoordinate2D locat = lo.coordinate;
//        NSLog(@"Lat %f  Long %f",lo.coordinate.latitude,lo.coordinate.longitude);
//        MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
//        MKCoordinateRegion region = MKCoordinateRegionMake(locat, span);
//        [mapView setRegion:region animated:YES];
//
//    }
    CLLocationCoordinate2D location = userLocation.coordinate;
    NSLog(@"Lat %f  Long %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [mapView setRegion:region animated:YES];
}

@end
