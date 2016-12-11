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

@class DBMenuSegmentedControlTableViewCell;

/**
 A protocol used for informing about changes in cell's segmented control.
 */
@protocol DBMenuSegmentedControlTableViewCellDelegate <NSObject>

/**
 Informs the delegate that the selected segment was changed in the cell.
 
 @param menuSegmentedControlTableViewCell The cell with a segmented control that changed selected segment.
 @param index The selected segment index.
 */
- (void)menuSegmentedControlTableViewCell:(DBMenuSegmentedControlTableViewCell *)menuSegmentedControlTableViewCell didSelectSegmentAtIndex:(NSUInteger)index;

@end

/**
 `DBMenuSegmentedControlTableViewCell` is a simple table view cell subclass with a centered `UISegmentedControl`.
 */
@interface DBMenuSegmentedControlTableViewCell : UITableViewCell

/**
 Delegate that will be informed about changes in segmented control. It needs to conform to `DBMenuSegmentedControlTableViewCellDelegate` protocol.
 */
@property (nonatomic, weak) id <DBMenuSegmentedControlTableViewCellDelegate> delegate;

/**
 An outlet to `UISegmentedControl` instance.
 */
@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentedControl;

/**
 Configures the cell with segment titles and the selected segment index.
 
 @param titles Titles for segments.
 @param selectedIndex The initial selected segment index.
 */
- (void)configureWithTitles:(NSArray <NSString *> *)titles selectedIndex:(NSUInteger)selectedIndex;

@end
