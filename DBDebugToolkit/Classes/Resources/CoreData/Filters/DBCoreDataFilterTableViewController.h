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
#import "DBCoreDataFilter.h"

@class DBCoreDataFilterTableViewController;

/**
 A protocol used for informing about closing or saving changes in the filter table view controller.
 */
@protocol DBCoreDataFilterTableViewControllerDelegate <NSObject>

/**
 Informs the delegate that the user tapped the close button on the navigation bar.
 
 @param filterTableViewController The `DBCoreDataFilterTableViewController` that received the close button tap.
 */
- (void)filterTableViewControllerDidTapClose:(DBCoreDataFilterTableViewController *)filterTableViewController;

/**
 Informs the delegate that the user tapped the save button on the navigation bar.
 
 @param filterTableViewController The `DBCoreDataFilterTableViewController` that received the save button tap.
 @param filter The filter that needs to be saved.
 */
- (void)filterTableViewController:(DBCoreDataFilterTableViewController *)filterTableViewController didTapSaveWithFilter:(DBCoreDataFilter *)filter;

@end

/**
 `DBCoreDataFilterTableViewController` is a table view controller allowing the user to modify one of the filters.
 */
@interface DBCoreDataFilterTableViewController : UITableViewController

/**
 The modified filter.
 */
@property (nonatomic, strong) DBCoreDataFilter *filter;

/**
 An array of the attributes that can be used for filtering.
 */
@property (nonatomic, strong) NSArray <NSAttributeDescription *> *attributes;

/**
 The delegate that will be informed about closing or saving changes in the filter table view controller. It needs to conform to the `DBCoreDataFilterTableViewControllerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBCoreDataFilterTableViewControllerDelegate> delegate;

@end
