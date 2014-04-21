//
//  PModelController.h
//  Places
//
//  Created by Tim Macfarlane on 31/03/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPlacesQueryDelegate.h"
#import "PModelControllerDelegate.h"

@class PPlaceViewController;

@interface PModelController : NSObject <UIPageViewControllerDataSource, PPlacesQueryDelegate>

- (PPlaceViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(PPlaceViewController *)viewController;
- (void)refresh;

@property (weak, nonatomic, readwrite) id<PModelControllerDelegate> delegate;

@end
