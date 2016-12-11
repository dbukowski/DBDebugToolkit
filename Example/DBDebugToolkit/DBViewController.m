//
//  DBViewController.m
//  DBDebugToolkit
//
//  Created by Dariusz Bukowski on 11/19/2016.
//  Copyright (c) 2016 Dariusz Bukowski. All rights reserved.
//

#import "DBViewController.h"

@interface DBViewController () <UIScrollViewDelegate>

@end

@implementation DBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    fprintf(stderr, "fprintf to stderr: %lf\n", scrollView.contentOffset.y);
    fprintf(stdout, "fprintf to stdout: %lf\n", scrollView.contentOffset.y);
    NSLog(@"NSLog: %lf", scrollView.contentOffset.y);
}

@end
