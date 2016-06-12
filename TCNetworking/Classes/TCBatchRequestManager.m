//
//  TCBatchRequestManager.m
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/26.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCBatchRequestManager.h"

@interface TCBatchRequestManager()

@property (nonatomic, copy) void(^success)(NSArray *responses);
@property (nonatomic, copy) void(^failure)(NSArray *responses, NSArray *errors);
@property (nonatomic, strong) TCBaseAPIClient *client;
@property (nonatomic, strong) NSMutableDictionary *requestTasks;

@end

@implementation TCBatchRequestManager

/**
 *  批量网络请求类
 *
 *  @param success 全部成功回调
 *  @param failure 只要有一个失败就回调该block
 *  @param client  API客户端
 *
 *  @return TCBatchRequestManager
 */
- (instancetype)initWithSuccessBlock:(void(^)(NSArray *responses))success
                             failure:(void(^)(NSArray *responses, NSArray *errors))failure
                           useClient:(TCBaseAPIClient *)client {
    
    if (self = [super init]) {
        _success = success;
        _failure = failure;
        _client = client;
        _requestTasks = [NSMutableDictionary dictionary];
    }
    return self;
}

/**
 *  添加批量请求
 *
 *  @param requests 批量请求数组
 */
- (void)addBatchRequest:(NSArray<TCBatchRequest *> *)requests {
    
}

/**
 *  启动批量请求
 */
- (void)startRequest {
    
}

@end
