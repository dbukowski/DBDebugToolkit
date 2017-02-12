//
//  DBCookieDetailsTableViewController.h
//  Pods
//
//  Created by Dariusz Bukowski on 12.02.2017.
//
//

#import <UIKit/UIKit.h>

@class DBCookieDetailsTableViewController;

@protocol DBCookieDetailsTableViewControllerDelegate

- (void)cookieDetailsTableViewController:(DBCookieDetailsTableViewController *)cookieDetailsTableViewController didTapDeleteWithCookie:(NSHTTPCookie *)cookie;

@end

@interface DBCookieDetailsTableViewController : UITableViewController

@property (nonatomic, strong) NSHTTPCookie *cookie;

@property (nonatomic, weak) id <DBCookieDetailsTableViewControllerDelegate> delegate;

@end
