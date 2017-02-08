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
    CLLocationCoordinate2D location = userLocation.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    [mapView setRegion:region animated:YES];
}

@end
