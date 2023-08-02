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

@class DBOptionsListTableViewController;

/**
 A protocol used for passing the information about selected option index.
 */
@protocol DBOptionsListTableViewControllerDelegate <NSObject>

/**
 Informs the delegate that the user selected the option at the given index.
 
 @params optionsListTableViewController The table view controller that received the option selection.
 @params optionIndex Index of the selected option.
 */
- (void)optionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController didSelectOptionAtIndex:(NSInteger)optionIndex;

@end

/**
 A protocol used for providing the information about the available options to the `DBOptionsListTableViewController` instance.
 */
@protocol DBOptionsListTableViewControllerDataSource <NSObject>

/**
 Provides the number of all the available options.
 
 @params optionsListTableViewController The table view controller that needs the number of all the available options.
 */
- (NSInteger)numberOfOptionsInOptionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController;

/**
 Provides the index of the selected option.
 
 @params optionsListTableViewController The table view controller that needs the index of the selected option.
 */
- (NSInteger)selectedIndexInOptionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController;

/**
 Provides the title for the option at the given index.
 
 @params optionsListTableViewController The table view controller that needs the title for the option.
 @params index Index of the option requiring a title.
 */
- (NSString *)optionsListTableViewController:(DBOptionsListTableViewController *)optionsListTableViewController titleAtIndex:(NSInteger)index;

@end

/**
 `DBOptionsListTableViewController` is a simple table view controller allowing the user to choose one of the options.
 */
@interface DBOptionsListTableViewController : UITableViewController

/**
 The object that will provide the information about available options. It needs to conform to the `DBOptionsListTableViewControllerDataSource` protocol.
 */
@property (nonatomic, weak) id <DBOptionsListTableViewControllerDataSource> dataSource;

/**
 The object that will be informed about selected option. It needs to conform to the `DBOptionsListTableViewControllerDelegate` protocol.
 */
@property (nonatomic, weak) id <DBOptionsListTableViewControllerDelegate> delegate;

@end
