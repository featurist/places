//
//  PCurrentLocationDelegate.h
//  Places
//
//  Created by Tim Macfarlane on 18/04/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PCurrentLocationDelegate <NSObject>

- (void)currentLocation:(PCurrentLocation*) didUpdateLocations:(NSArray *)locations;

@end
