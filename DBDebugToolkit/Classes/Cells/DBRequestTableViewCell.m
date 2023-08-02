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

#import "DBRequestTableViewCell.h"

@interface DBRequestTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *responseTypeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *httpMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *resourcePathLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resourcePathLabelLeadingConstraint;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *responseDetailsLabel;

@end

@implementation DBRequestTableViewCell

- (void)configureWithRequestModel:(DBRequestModel *)requestModel {
    [self configureThumbnailViewWithRequestModel:requestModel];
    [self configureRequestLabelsWithRequestModel:requestModel];
    [self configureResponseLabelWithRequestModel:requestModel];
}

#pragma mark - Private methods

- (void)configureThumbnailViewWithRequestModel:(DBRequestModel *)requestModel {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.alpha = 0.0;
    self.responseTypeLabel.alpha = 0.0;
    self.thumbnailImageView.alpha = 0.0;
    if (requestModel.didFinishWithError) {
        self.responseTypeLabel.text = @"ERROR";
        self.responseTypeLabel.alpha = 1.0;
    } else if (requestModel.responseBodySynchronizationStatus != DBRequestModelBodySynchronizationStatusFinished) {
        [self.activityIndicator startAnimating];
        self.activityIndicator.alpha = 1.0;
    } else {
        if (requestModel.responseBodyType == DBRequestModelBodyTypeImage) {
            self.thumbnailImageView.image = requestModel.thumbnail;
            self.thumbnailImageView.alpha = 1.0;
        } else {
            self.responseTypeLabel.text = requestModel.responseBodyType == DBRequestModelBodyTypeJSON ? @"JSON" : @"TEXT";
            self.responseTypeLabel.alpha = 1.0;
        }
    }
}

- (void)configureRequestLabelsWithRequestModel:(DBRequestModel *)requestModel {
    if (requestModel.httpMethod.length > 0) {
        self.httpMethodLabel.text = requestModel.httpMethod.uppercaseString;
        self.resourcePathLabelLeadingConstraint.constant = 4;
    } else {
        self.httpMethodLabel.text = nil;
        self.resourcePathLabelLeadingConstraint.constant = 0;
    }
    self.resourcePathLabel.text = requestModel.url.relativePath;
    self.hostLabel.text = requestModel.url.host;
}

- (void)configureResponseLabelWithRequestModel:(DBRequestModel *)requestModel {
    if (!requestModel.finished) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:requestModel.sendingDate
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterMediumStyle];
        self.responseDetailsLabel.text = [NSString stringWithFormat:@"Sent at %@...", dateString];
    } else if (requestModel.didFinishWithError) {
        self.responseDetailsLabel.text = [NSString stringWithFormat:@"Error %ld: %@", (long)requestModel.errorCode, requestModel.localizedErrorDescription];
    } else {
        NSMutableString *responseString = [NSMutableString stringWithFormat:@"%.2lfs", requestModel.duration];
        if (requestModel.statusCode) {
            [responseString appendFormat:@", HTTP %@", requestModel.statusCode];
            if (requestModel.localizedStatusCodeString) {
                [responseString appendFormat:@" - %@", requestModel.localizedStatusCodeString];
            }
        }
        self.responseDetailsLabel.text = responseString;
    }
}

@end
