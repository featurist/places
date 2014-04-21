//
//  PCurrentLocation.m
//  Places
//
//  Created by Tim Macfarlane on 15/04/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import "PPlacesQuery.h"
#import <BlocksKit.h>
#import "PApiClient.h"

@interface PPlacesQuery() {
    CLLocationManager *locationManager;
    CLLocation *lastLocation;
}

@property (readonly, strong, nonatomic) PApiClient *api;

@end

@implementation PPlacesQuery

- (id)init {
    _api = [[PApiClient alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 5.0;
    [locationManager startUpdatingLocation];
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if ([locations count] >= 1) {
        CLLocation *location = [locations objectAtIndex:0];
        
        [self queryWithLocation:location];
    }
}

- (void)queryWithLocation:(CLLocation*)location {
    [_api locations:^(NSArray *places) {
        [_delegate placesQuery:self updatedResults:places];
    } forLat:location.coordinate.latitude long:location.coordinate.longitude failure:^(NSError *error) {
        NSLog(@"error while accessing api: %@", error);
    }];
}

- (void)refresh {
    if (lastLocation) {
        [self queryWithLocation:lastLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
}

- (void)location:(void (^)(float latitude, float longitude))block {
    block(2.3, 4.5);
}

@end
