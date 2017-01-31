//
//  DBRequestDetailsViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 30.01.2017.
//
//

#import <UIKit/UIKit.h>
#import "DBRequestModel.h"

@class DBRequestDetailsViewController;

@protocol DBRequestDetailsViewControllerDelegate <NSObject>

- (void)requestDetailsViewControllerDidDismiss:(DBRequestDetailsViewController *)requestDetailsViewController;

@end

@interface DBRequestDetailsViewController : UIViewController

@property (nonatomic, weak) id <DBRequestDetailsViewControllerDelegate> delegate;

- (void)updateRequestModel:(DBRequestModel *)requestModel;

@end
