//
//  PDataViewController.m
//  Places
//
//  Created by Tim Macfarlane on 31/03/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import "PPlaceViewController.h"
#import <GPUImage.h>

@interface PPlaceViewController ()

@end

@implementation PPlaceViewController

@synthesize description, image;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    showingDescription = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIImage*) blurImage:(UIImage*)inputImage {
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageGaussianBlurFilter *blur = [[GPUImageGaussianBlurFilter alloc] init];
    GPUImageBrightnessFilter *brightness = [[GPUImageBrightnessFilter alloc] init];
    brightness.brightness = -0.05;
    
    [stillImageSource addTarget:blur];
    [blur addTarget:brightness];
    [brightness useNextFrameForImageCapture];
    [stillImageSource processImage];
    
    return [brightness imageFromCurrentFramebuffer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSData *imageData = [NSData dataWithContentsOfURL:_place.imageURL];
    self.originalImage = [[UIImage alloc] initWithData:imageData];
    self.image.image = self.originalImage;
    
    self.blurredImage.image = [self blurImage:self.originalImage];

    NSError *error;
    NSString *htmlTemplate = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"description.html" ofType:nil] encoding:NSUTF8StringEncoding error:&error];
    NSString *html = [NSString stringWithFormat:htmlTemplate, _place.placeDescription];
    
    [self.description loadHTMLString:html baseURL:[NSURL URLWithString:@"http://localhost/"]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self setShowingDescription:NO];
}

- (void)setShowingDescription:(BOOL)showing {
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
