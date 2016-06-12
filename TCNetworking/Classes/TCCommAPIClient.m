//
//  TCCommAPIClient.m
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/23.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCCommAPIClient.h"

@implementation TCCommAPIClient

+ (instancetype)sharedInstance {
    static TCCommAPIClient *_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _client = [TCCommAPIClient clientWithBaseURL:nil];
    });
    return _client;
}

@end
