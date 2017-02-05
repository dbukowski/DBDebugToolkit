//
//  DBTextViewViewController.m
//  Pods
//
//  Created by Dariusz Bukowski on 04.02.2017.
//
//

#import "DBTextViewViewController.h"

@interface DBTextViewViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, copy) NSString *text;

@end

@implementation DBTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.layoutManager.allowsNonContiguousLayout = NO;
    [self updateText:self.text];
}

- (void)configureWithTitle:(NSString *)title text:(NSString *)text {
    self.title = title;
    [self updateText:text];
}

#pragma mark - Private methods

- (void)updateText:(NSString *)text {
    self.text = text;
    self.textView.text = text;
}

@end
