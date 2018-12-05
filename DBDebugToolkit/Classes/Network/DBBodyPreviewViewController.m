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

#import "DBBodyPreviewViewController.h"

typedef NS_ENUM(NSUInteger, DBBodyPreviewViewControllerViewState) {
    DBBodyPreviewViewControllerViewStateLoading,
    DBBodyPreviewViewControllerViewStateShowingText,
    DBBodyPreviewViewControllerViewStateShowingImage,
};

@interface DBBodyPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DBBodyPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)configureWithRequestModel:(DBRequestModel *)requestModel mode:(DBBodyPreviewViewControllerMode)mode {
    self.title = mode == DBBodyPreviewViewControllerModeRequest ? @"Request body" : @"Response body";
    [self setViewState:DBBodyPreviewViewControllerViewStateLoading animated:YES];
    DBRequestModelBodyType bodyType = mode == DBBodyPreviewViewControllerModeRequest ? requestModel.requestBodyType : requestModel.responseBodyType;
    void (^completion)(NSData *) = ^void(NSData *data) {
        if (bodyType == DBRequestModelBodyTypeImage) {
            self.imageView.image = [UIImage imageWithData:data];
            [self setViewState:DBBodyPreviewViewControllerViewStateShowingImage animated:YES];
        } else {
            NSString *dataString;
            if (bodyType == DBRequestModelBodyTypeJSON) {
                NSError *error;
                NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data ?: [NSData data]
                                                                                         options:NSJSONReadingAllowFragments
                                                                                           error:&error];
                if (error) {
                    dataString = @"Unable to read the data.";
                } else {
                    data = [NSJSONSerialization dataWithJSONObject:jsonSerialization options:NSJSONWritingPrettyPrinted error:nil];
                    dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    dataString = [dataString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
                }
            } else {
                NSString *UTF8DecodedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if (UTF8DecodedString == nil) {
                    NSMutableString *mutableDataString = [NSMutableString stringWithCapacity:data.length * 2];
                    const unsigned char *dataBytes = [data bytes];
                    for (NSInteger index = 0; index < data.length; index++) {
                        [mutableDataString appendFormat:@"%02x", dataBytes[index]];
                    }
                    dataString = [mutableDataString copy];
                } else {
                    dataString = UTF8DecodedString;
                }
            }
            self.textView.text = dataString;
            [self setViewState:DBBodyPreviewViewControllerViewStateShowingText animated:YES];
        }
    };
    if (mode == DBBodyPreviewViewControllerModeRequest) {
        [requestModel readRequestBodyWithCompletion:completion];
    } else {
        [requestModel readResponseBodyWithCompletion:completion];
    }
}

- (void)setViewState:(DBBodyPreviewViewControllerViewState)state animated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.35 : 0.0 animations:^{
        self.activityIndicator.alpha = 0.0;
        self.textView.alpha = 0.0;
        self.imageView.alpha = 0.0;
        switch (state) {
            case DBBodyPreviewViewControllerViewStateLoading: {
                [self.activityIndicator startAnimating];
                self.activityIndicator.alpha = 1.0;
                break;
            }
            case DBBodyPreviewViewControllerViewStateShowingText:
                self.textView.alpha = 1.0;
                break;
            case DBBodyPreviewViewControllerViewStateShowingImage:
                self.imageView.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        if (state != DBBodyPreviewViewControllerViewStateLoading) {
            [self.activityIndicator stopAnimating];
        }
    }];
}

@end
