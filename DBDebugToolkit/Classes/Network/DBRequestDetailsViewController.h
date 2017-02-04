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
#import "DBRequestModel.h"

@class DBRequestDetailsViewController;

/**
 A protocol used for informing the presenting view controller about the dismissing of the `DBRequestDetailsViewController` instance.
 */
@protocol DBRequestDetailsViewControllerDelegate <NSObject>

/**
 Informs the delegate that it will be dismissed.
 
 @param requestDetailsViewController The `DBRequestDetailsViewController` that is being dismissed.
 */
- (void)requestDetailsViewControllerDidDismiss:(DBRequestDetailsViewController *)requestDetailsViewController;

@end

/**
 `DBRequestDetailsViewController` is a view controller displaying all the information about a given request sent by the application.
 */
@interface DBRequestDetailsViewController : UIViewController

/**
 Delegate that will be informed about the dismissing of the view controller. It needs to conform to `DBRequestDetailsViewControllerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBRequestDetailsViewControllerDelegate> delegate;

/**
 Configures the view controller with a `DBRequestModel` instance.
 
 @param requestModel `DBRequestModel` instance containing all the information about the logged request.
 */
- (void)configureWithRequestModel:(DBRequestModel *)requestModel;

@end
