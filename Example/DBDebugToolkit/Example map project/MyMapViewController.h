//
//  MyMapViewController.h
//  DBDebugToolkit_Example
//
//  Created by gurleen singh on 14/8/18.
//  Copyright © 2018 Dariusz Bukowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <DBDebugToolkit/DBDebugToolkit.h>
#import <DBDebugToolkit/CLLocationManager+DBLocationToolkit.h>
@interface MyMapViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
