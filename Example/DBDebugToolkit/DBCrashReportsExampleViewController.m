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
    void (*nullFunction)(void) = NULL;
    nullFunction();
}

- (IBAction)unrecognizedSelectorAction:(id)sender {
    [self performSelector:@selector(count)];
}

- (IBAction)indexOutOfBoundsAction:(id)sender {
    NSArray *arr = [NSArray arrayWithObjects:@0, @1, @2, nil];
    NSLog(@"%@", arr[3]);
}

@end
