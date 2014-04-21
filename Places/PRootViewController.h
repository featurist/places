//
//  PRootViewController.h
//  Places
//
//  Created by Tim Macfarlane on 31/03/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PModelControllerDelegate.h"

@interface PRootViewController : UIViewController <UIPageViewControllerDelegate, PModelControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;

- (IBAction)refresh:(id)sender;

@end
