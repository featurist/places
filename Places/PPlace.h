//
//  PPlace.h
//  Places
//
//  Created by Tim Macfarlane on 18/04/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPlace : NSObject

@property (nonatomic, strong, readwrite) NSString *placeDescription;
@property (nonatomic, strong, readwrite) NSURL *imageURL;

@end
