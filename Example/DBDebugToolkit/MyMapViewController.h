//
//  MyMapViewController.h
//  DBDebugToolkit_Example
//
//  Created by gurleen singh on 14/8/18.
//  Copyright © 2018 Dariusz Bukowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MyMapViewController : UIViewController<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
