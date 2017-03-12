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

@class DBTextViewTableViewCell;

/**
 A protocol used for passing the text view delegate methods.
 */
@protocol DBTextViewTableViewCellDelegate <NSObject>

/**
 Informs the delegate that the text value was changed in the cell.
 
 @param textViewCell The cell with a text view that changed its value.
 */
- (void)textViewTableViewCellDidChangeText:(DBTextViewTableViewCell *)textViewCell;

/**
 Asks the delegate if the text can be changed to the given value in the text view.
 
 @param textViewCell The cell with a text view that requires new value validation.
 @param text The new text value that requires validation.
 */
- (BOOL)textViewTableViewCell:(DBTextViewTableViewCell *)textViewCell shouldChangeTextTo:(NSString *)text;

@end

/**
 `DBTextViewTableViewCell` is a table view cell displaying a title and a text view allowing the user to input a multiline content.
 */
@interface DBTextViewTableViewCell : UITableViewCell

/**
 An outlet to `UILabel` instance displaying the title of the value contained in the text view.
 */
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

/**
 An outlet to `UITextView` instance allowing the user to provide a multiline content.
 */
@property (nonatomic, weak) IBOutlet UITextView *textView;

/**
 Delegate that will be responsible for handling some of the `UITextViewDelegate` methods. It needs to conform to `DBTextViewTableViewCellDelegate` protocol.
 */
@property (nonatomic, weak) id <DBTextViewTableViewCellDelegate> delegate;

@end
