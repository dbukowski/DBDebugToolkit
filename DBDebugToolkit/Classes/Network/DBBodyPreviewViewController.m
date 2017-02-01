//
//  DBBodyPreviewViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 01.02.2017.
//
//

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
            if (bodyType == DBRequestModelBodyTypeJSON) {
                NSJSONSerialization *jsonSerialization = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                data = [NSJSONSerialization dataWithJSONObject:jsonSerialization options:NSJSONWritingPrettyPrinted error:nil];
            }
            self.textView.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
