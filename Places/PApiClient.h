//
//  PApiClient.h
//  Places
//
//  Created by Tim Macfarlane on 15/04/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PApiClient : NSObject

- (void) locations:(void (^)(NSArray*))block forLat:(float)latitude long:(float)longitude failure:(void (^)(NSError*))failure;

@end
