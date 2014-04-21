//
//  PApiClient.m
//  Places
//
//  Created by Tim Macfarlane on 15/04/2014.
//  Copyright (c) 2014 IMD. All rights reserved.
//

#import "PApiClient.h"
#import <AFNetworking.h>
#import <BlocksKit.h>
#import "PPlace.h"

@implementation PApiClient

- (void) locations:(void (^)(NSArray*))block forLat:(float)latitude long:(float)longitude failure:(void (^)(NSError*))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"lat": [NSNumber numberWithFloat: latitude],
                             @"long": [NSNumber numberWithFloat: longitude]
                             };
    
    NSURL *baseUrl = [NSURL URLWithString: @"http://localhost:4000/"];
    
    [manager GET:[[NSURL URLWithString:@"/places/nearest" relativeToURL:baseUrl] absoluteString] parameters:params success:^(AFHTTPRequestOperation *operation, NSArray *response) {
        NSLog(@"JSON: %@", response);
        
        NSArray *places = [response bk_map:^id(id apiPlace) {
            PPlace *place = [[PPlace alloc] init];
            place.placeDescription = apiPlace[@"description"];
            place.imageURL = [NSURL URLWithString:apiPlace[@"image"] relativeToURL:baseUrl];
            return place;
        }];
        
        block(places);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

@end
