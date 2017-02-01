//
//  DBBodyPreviewViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 01.02.2017.
//
//

#import <UIKit/UIKit.h>
#import "DBRequestModel.h"

typedef NS_ENUM(NSUInteger, DBBodyPreviewViewControllerMode) {
    DBBodyPreviewViewControllerModeRequest,
    DBBodyPreviewViewControllerModeResponse,
};

@interface DBBodyPreviewViewController : UIViewController

- (void)configureWithRequestModel:(DBRequestModel *)requestModel mode:(DBBodyPreviewViewControllerMode)mode;

@end
