//
//  TCBatchRequest.m
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/26.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCBatchRequest.h"

@interface TCBatchRequest()

@property (nonatomic, strong, readwrite) NSString *URLString;
@property (nonatomic, copy, readwrite) NSDictionary *parameters;

@end

@implementation TCBatchRequest

/**
 *  构造批量请求对象
 *
 *  @param URLString  请求URL
 *  @param parameters 请求参数
 *
 *  @return TCBatchRequest
 */
- (instancetype)initWithURL:(NSString *)URLString
                 parameters:(NSDictionary *)parameters {
    
    if (self = [super init]) {
        _URLString = URLString;
        _parameters = parameters;
    }
    return self;
}

@end
