//
//  TCBatchRequestManager.m
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/26.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCBatchRequestManager.h"
#import "TCBatchRequestOperation.h"

@interface TCBatchRequestManager()

@property (nonatomic, copy) void(^success)(NSDictionary *responses);
@property (nonatomic, copy) void(^failure)(NSDictionary *responses);
@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, strong) TCBaseAPIClient *client;
@property (nonatomic, strong) NSMutableArray *batchRequests;
@property (nonatomic, assign) BOOL canAddTask;

@property (nonatomic, strong) NSMutableDictionary *successResponses;
@property (nonatomic, strong) NSMutableDictionary *failureResponses;

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
- (instancetype)initWithSuccessBlock:(void(^)(NSDictionary *successResponses))success
                             failure:(void(^)(NSDictionary *errorResponses))failure
                           useClient:(TCBaseAPIClient *)client {
    
    if (self = [super init]) {
        _canAddTask = YES;
        _success = success;
        _failure = failure;
        _client = client;
        _batchRequests = [NSMutableArray array];
        _successResponses = [NSMutableDictionary dictionary];
        _failureResponses = [NSMutableDictionary dictionary];
        
        /**
         * 请求队列
         */
        _requestQueue = [[NSOperationQueue alloc] init];
        [_requestQueue setMaxConcurrentOperationCount:5];
    }
    return self;
}

/**
 *  添加批量请求
 *
 *  @param requests 批量请求数组
 */
- (void)addBatchRequests:(NSArray<TCBatchRequest *> *)requests {
    if (self.canAddTask) {
        [self.batchRequests addObjectsFromArray:requests];
    }
}

/**
 *  添加请求
 *
 *  @param request 请求对象
 */
- (void)addBatchRequest:(TCBatchRequest *)request {
    if (self.canAddTask) {
        [self.batchRequests addObject:request];
    }
}

/**
 *  启动批量请求
 */
- (void)startRequest {
    NSLog(@"开始批量请求...");
    self.canAddTask = NO; // 开始请求之后禁止添加任务
    @weakify(self)
    for (TCBatchRequest *batchRequest in self.batchRequests) {
        TCBatchRequestOperation *operation =
        [[TCBatchRequestOperation alloc] initWithBatchRequst:batchRequest
                                                     success:^(NSString *responseString, TCBatchRequest *batchRequest) {
                                                         NSLog(@"请求'%@'成功", batchRequest.URLString);
                                                         @strongify(self)
                                                         self.successResponses[[batchRequest description]] = responseString;
                                                         [self handleResponse];
                                                     } failure:^(NSError *error, TCBatchRequest *batchRequest) {
                                                         NSLog(@"请求'%@'失败", batchRequest.URLString);
                                                         @strongify(self)
                                                         self.failureResponses[[batchRequest description]] = error;
                                                         [self handleResponse];
                                                     }];
        operation.client = self.client;
        [self.requestQueue addOperation:operation];
    }
}

- (void)handleResponse {
    if (self.successResponses.count + self.failureResponses.count == self.batchRequests.count) {
        if (self.successResponses.count > 0) {
            self.success(self.successResponses);
        }
        if (self.failureResponses.count > 0) {
            self.failure(self.failureResponses);
        }
        self.canAddTask = YES;
        NSLog(@"完成批量请求...");
    }
}

@end
