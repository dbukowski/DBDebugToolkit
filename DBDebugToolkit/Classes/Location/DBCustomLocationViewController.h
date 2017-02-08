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

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class DBCustomLocationViewController;

/**
 A protocol used for informing the presenting view controller about the new selected location and about the need to dismiss the `DBCustomLocationViewController` instance.
 */
@protocol DBCustomLocationViewControllerDelegate <NSObject>

/**
 Informs the delegate that the user finished selecting a new location.
 
 @param customLocationViewController The `DBCustomLocationViewController` that has a new location and needs to be dismissed.
 @param location The selected location.
 */
- (void)customLocationViewController:(DBCustomLocationViewController *)customLocationViewController
                   didSelectLocation:(CLLocation *)location;

/**
 Informs the delegate that the user cancelled selecting a new location.
 
 @param customLocationViewController The `DBCustomLocationViewController` that needs to be dismissed.
 */
- (void)customLocationViewControllerDidTapCancelButton:(DBCustomLocationViewController *)customLocationViewController;

@end

/**
 `DBCustomLocationViewController` is a simple view controller allowing the user to select a location on a map.
 */
@interface DBCustomLocationViewController : UIViewController

/**
 The currently selected location. Can be used to provide the location before showing `DBCustomLocationViewController` instance.
 */
@property (nonatomic, strong) CLLocation *selectedLocation;

/**
 Delegate that will be informed about the new selected location and about the need to dismiss the presented view controller. It needs to conform to `DBCustomLocationViewControllerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBCustomLocationViewControllerDelegate> delegate;

@end
