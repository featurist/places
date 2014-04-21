//
//  PPlacesQueryDelegate.h
//  Places
//
//  Created by Tim Macfarlane on 18/04/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PPlacesQuery;

@protocol PPlacesQueryDelegate <NSObject>

- (void)placesQuery:(PPlacesQuery*)placesQuery updatedResults:(NSArray*)places;

@end
