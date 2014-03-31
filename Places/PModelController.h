//
//  PModelController.h
//  Places
//
//  Created by Tim Macfarlane on 31/03/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDataViewController;

@interface PModelController : NSObject <UIPageViewControllerDataSource>

- (PDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(PDataViewController *)viewController;

@end
