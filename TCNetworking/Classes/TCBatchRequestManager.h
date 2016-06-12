//
//  TCBatchRequestManager.h
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/26.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCBatchRequest.h"
#import "TCBaseAPIClient.h"

@interface TCBatchRequestManager : NSObject

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
                           useClient:(TCBaseAPIClient *)client;

/**
 *  添加批量请求
 *
 *  @param requests 批量请求数组
 */
- (void)addBatchRequest:(NSArray<TCBatchRequest *> *)requests;

/**
 *  启动批量请求
 */
- (void)startRequest;

@end