//
//  DBRequestTableViewCell.m
//  Pods
//
//  Created by Dariusz Bukowski on 24.01.2017.
//
//

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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

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
    } else if (requestModel.responseBodyType == DBRequestModelBodyTypeNotDetermined) {
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
        self.responseDetailsLabel.text = [NSString stringWithFormat:@"Sent at %@...", requestModel.sendingDate];
    } else if (requestModel.didFinishWithError) {
        self.responseDetailsLabel.text = [NSString stringWithFormat:@"Error %ld: %@", requestModel.errorCode, requestModel.localizedErrorDescription];
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
