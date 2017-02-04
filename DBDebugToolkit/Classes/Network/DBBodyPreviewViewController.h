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

/**
 Enum used for `DBBodyPreviewViewController` instance configuration.
 */
typedef NS_ENUM(NSUInteger, DBBodyPreviewViewControllerMode) {
    DBBodyPreviewViewControllerModeRequest,
    DBBodyPreviewViewControllerModeResponse,
};

/**
 `DBBodyPreviewViewController` is a view controller displaying a preview of the request or response body.
 It handles image, JSON and text data.
 */
@interface DBBodyPreviewViewController : UIViewController

/**
 Configures the view with request and mode.
 
 @param requestModel `DBRequestModel` instance containing all the information about the logged request.
 @param mode `DBBodyPreviewViewControllerMode` value determining the view controller title and which body (request or response) should be accessed.
 */
- (void)configureWithRequestModel:(DBRequestModel *)requestModel mode:(DBBodyPreviewViewControllerMode)mode;

@end
