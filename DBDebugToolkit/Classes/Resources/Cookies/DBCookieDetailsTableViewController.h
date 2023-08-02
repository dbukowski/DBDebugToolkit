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

@class DBCookieDetailsTableViewController;

/**
 A protocol used for passing the information about tapping the delete button on the navigation bar.
 */
@protocol DBCookieDetailsTableViewControllerDelegate

/**
 Informs the delegate about tapping the delete button on the navigation bar.
 
 @param cookieDetailsTableViewController The `DBCookieDetailsTableViewController` instance that recorded the tap.
 @param cookie The cookie that the user chose to delete.
 */
- (void)cookieDetailsTableViewController:(DBCookieDetailsTableViewController *)cookieDetailsTableViewController didTapDeleteWithCookie:(NSHTTPCookie *)cookie;

@end

/**
 `DBCookieDetailsTableViewController` is a table view controller presenting the details of the given `NSHTTPCookie` instance.
 */
@interface DBCookieDetailsTableViewController : UITableViewController

/**
 `NSHTTPCookie` instance that will serve as a data source.
 */
@property (nonatomic, strong) NSHTTPCookie *cookie;

/**
 The delegate that will be informed about tapping the delete button on the navigation bar. It needs to conform to `DBCookieDetailsTableViewControllerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBCookieDetailsTableViewControllerDelegate> delegate;

@end
