//
//  PDataViewController.h
//  Places
//
//  Created by Tim Macfarlane on 31/03/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPlace.h"

@interface PPlaceViewController : UIViewController {
    BOOL showingDescription;
}

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *blurredImage;
@property (strong, nonatomic) IBOutlet UIWebView *description;
@property (strong, nonatomic) PPlace *place;

@property (strong, nonatomic) UIImage *originalImage;

- (IBAction)toggleDescription:(id)sender;

@end
