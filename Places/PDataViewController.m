//
//  PDataViewController.m
//  Places
//
//  Created by Tim Macfarlane on 31/03/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import "PDataViewController.h"

@interface PDataViewController ()

@end

@implementation PDataViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.image.image = [UIImage imageWithContentsOfFile:self.dataObject];
    
    NSLog(@"view did appear: %@", self.dataObject);
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear: %@", self.dataObject);
}

@end
