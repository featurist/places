//
//  PDataViewController.m
//  Places
//
//  Created by Tim Macfarlane on 31/03/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import "PDataViewController.h"
#import <UIImage-Helpers.h>

@interface PDataViewController ()

@end

@implementation PDataViewController

@synthesize description, image;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    showingDescription = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.originalImage = [UIImage imageWithContentsOfFile:self.dataObject];
    self.image.image = self.originalImage;
    self.blurredImage.image = [self.originalImage blurredImage:10.0f];
//    self.blurredImage.image = self.originalImage;
    

    NSError *error;
    NSString *htmlTemplate = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"description.html" ofType:nil] encoding:NSUTF8StringEncoding error:&error];
    NSString *html = [NSString stringWithFormat:htmlTemplate, self.dataObject];
    
    [self.description loadHTMLString:html baseURL:[NSURL URLWithString:@"http://localhost/"]];
    
    NSLog(@"view did appear: %@", self.dataObject);
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"view did disappear: %@", self.dataObject);
    
    [self setShowingDescription:NO];
}

- (void)setShowingDescription:(BOOL)showing {
    NSLog(@"show description");
    
    if (showingDescription != showing) {
        if (showing) {
            [UIView animateWithDuration:0.25f animations:^{
                self.description.alpha = 1.0f;
                self.blurredImage.alpha = 1.0f;
            }];
        } else {
            [UIView animateWithDuration:0.25f animations:^{
                self.description.alpha = 0.0f;
                self.blurredImage.alpha = 0.0f;
            }];
        }
    }
    
    showingDescription = showing;
}

- (IBAction)toggleDescription:(id)sender {
    [self setShowingDescription:!showingDescription];
}

@end
