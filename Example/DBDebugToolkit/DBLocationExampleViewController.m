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
    NSMutableArray *latArray, *longArray, *arrLocations, *array;
    CLLocationCoordinate2D location;
    NSTimer *timer;
    int counter;

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

- (void)coutnerCalled {
    if (counter>=[array count]) {
        counter = 0;
    }
    MKUserLocation *loc = [MKUserLocation new];
    loc = [array objectAtIndex:counter++];
    NSLog(@"%@",loc);
    [self mapView:self.mapView didUpdateUserLocation:loc];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    
    CLLocation *location;
    arrLocations = [NSMutableArray new];
    if (locations.count>0) {
        counter = locations.count;
        arrLocations = [locations mutableCopy];
        array = [NSMutableArray new];
        for (CLLocation *lo in locations){
            MKUserLocation *loc = [MKUserLocation new];
            loc.coordinate = lo.coordinate;
            [array addObject: loc];
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(coutnerCalled) userInfo:nil repeats:YES];
    } else {
    location = locations.lastObject;
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
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D location = userLocation.coordinate;
    NSLog(@"Lat %f  Long %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05, 0.05);
    MKCoordinateRegion region = MKCoordinateRegionMake(location, span);
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = userLocation.title;
    [self.mapView addAnnotation:point];
    [mapView setRegion:region animated:YES];
}

@end
