//
//  PModelControllerDelegate.h
//  Places
//
//  Created by Tim Macfarlane on 18/04/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PModelController;

@protocol PModelControllerDelegate <NSObject>

- (void)modelDidUpdate:(PModelController*)model;

@end
