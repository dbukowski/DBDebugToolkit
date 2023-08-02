//
//  DBCrashReportsExampleViewController.m
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 05.06.2017.
//  Copyright © 2017 Dariusz Bukowski. All rights reserved.
//

#import "DBCrashReportsExampleViewController.h"

@interface DBCrashReportsExampleViewController ()

@end

@implementation DBCrashReportsExampleViewController

- (IBAction)callingNullFunctionAction:(id)sender {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
    void (*nullFunction)(void) = NULL;
    nullFunction();
    });
}

- (IBAction)unrecognizedSelectorAction:(id)sender {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
    [self performSelector:@selector(count)];
    });
}

- (IBAction)indexOutOfBoundsAction:(id)sender {
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
    NSArray *arr = [NSArray arrayWithObjects:@0, @1, @2, nil];
    NSLog(@"%@", arr[3]);
    });
}

@end
