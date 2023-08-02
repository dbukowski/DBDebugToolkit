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

#import "DBCustomLocationViewController.h"
#import <MapKit/MapKit.h>

@interface DBCustomLocationViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) MKPointAnnotation *selectedLocationAnnotation;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation DBCustomLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGestureRecognizer];
    if (self.selectedLocation) {
        [self.mapView setCenterCoordinate:self.selectedLocation.coordinate];
        self.selectedLocationAnnotation.coordinate = self.selectedLocation.coordinate;
        [self.mapView addAnnotation:self.selectedLocationAnnotation];
    }
}

#pragma mark - Navigation bar button actions

- (IBAction)cancelButtonAction:(id)sender {
    [self.delegate customLocationViewControllerDidTapCancelButton:self];
}

- (IBAction)doneButtonAction:(id)sender {
    [self.delegate customLocationViewController:self
                              didSelectLocation:self.selectedLocation];
}

#pragma mark - Selected location

- (MKPointAnnotation *)selectedLocationAnnotation {
    if (!_selectedLocationAnnotation) {
        _selectedLocationAnnotation = [[MKPointAnnotation alloc] init];
    }
    
    return _selectedLocationAnnotation;
}

#pragma mark - Gesture recognizer

- (void)setupGestureRecognizer {
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.mapView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint tapPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:tapPoint toCoordinateFromView:self.mapView];
    self.selectedLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude
                                                       longitude:coordinate.longitude];
    self.selectedLocationAnnotation.coordinate = coordinate;
    [self.mapView addAnnotation:self.selectedLocationAnnotation];
    self.doneButton.enabled = YES;
}

@end
