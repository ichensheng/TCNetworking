//
//  TCBatchRequestOperation.h
//  TCNetworking
//
//  Created by 陈 胜 on 16/6/27.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCBaseAPIClient.h"
#import "TCBatchRequest.h"

typedef void (^TCBatchRequestSuccessBlock)(NSString *responseString, TCBatchRequest *batchRequest);
typedef void (^TCBatchRequestFailureBlock)(NSError *error,  TCBatchRequest *batchRequest);

@interface TCBatchRequestOperation : NSOperation

@property (nonatomic, strong) TCBaseAPIClient *client;

/**
 *  创建一个批量请求Operation
 *
 *  @param batchRequest 请求对象
 *  @param success      成功回调
 *  @param failure      失败回调
 *
 *  @return TCBatchRequestOperation
 */
- (instancetype)initWithBatchRequst:(TCBatchRequest *)request
                            success:(TCBatchRequestSuccessBlock)success
                            failure:(TCBatchRequestFailureBlock)failure;

@end
