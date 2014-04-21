//
//  PModelController.m
//  Places
//
//  Created by Tim Macfarlane on 31/03/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import "PModelController.h"
#import "PPlaceViewController.h"
#import <BlocksKit.h>
#import "PPlacesQuery.h"
#import "PApiClient.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface PModelController()
@property (readonly, strong, nonatomic) NSArray *places;
@property (readonly, strong, nonatomic) PPlacesQuery *placesQuery;
@property (readonly, strong, nonatomic) PApiClient *apiClient;
@end

@implementation PModelController

- (id)init
{
    self = [super init];
    if (self) {
        _placesQuery = [[PPlacesQuery alloc] init];
        _placesQuery.delegate = self;
    }
    return self;
}

- (void)refresh {
    [_placesQuery refresh];
}

- (void)placesQuery:(PPlacesQuery*)placesQuery updatedResults:(NSArray*)places {
    _places = places;
    
    [_delegate modelDidUpdate:self];
}

- (PPlaceViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([_places count] == 0) || (index >= [_places count])) {
        return [storyboard instantiateViewControllerWithIdentifier:@"PNoDataViewController"];
    }
    
    // Create a new view controller and pass suitable data.
    PPlaceViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"PDataViewController"];
    dataViewController.place = _places[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(PPlaceViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [_places indexOfObject:viewController.place];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PPlaceViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(PPlaceViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.places count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
