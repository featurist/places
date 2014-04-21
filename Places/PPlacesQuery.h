//
//  PCurrentLocation.h
//  Places
//
//  Created by Tim Macfarlane on 15/04/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "PPlacesQueryDelegate.h"

@interface PPlacesQuery : NSObject<CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

- (void)refresh;

@property (nonatomic, readwrite, weak) id<PPlacesQueryDelegate> delegate;

@end
