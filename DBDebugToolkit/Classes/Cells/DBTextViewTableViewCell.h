//
//  DBTextViewTableViewCell.h
//  Pods
//
//  Created by Dariusz Bukowski on 05.03.2017.
//
//

#import <UIKit/UIKit.h>

@interface DBTextViewTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *textView;

@end
