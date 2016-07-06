//
//  TCBaseAPIClient.m
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/23.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCBaseAPIClient.h"

@implementation TCBaseAPIClient

/**
 *  通过base url创建网络访问对象
 *
 *  @param url api基路径
 *
 *  @return TCBaseAPIClient
 */
+ (instancetype)clientWithBaseURL:(NSURL *)url {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 设置缓存大小，其中内存缓存大小设置10M、磁盘缓存50M
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                      diskCapacity:50 * 1024 * 1024
                                                          diskPath:nil];
    [config setURLCache:cache];
    TCBaseAPIClient *manager = nil;
    if (url) {
        manager = [[self alloc] initWithBaseURL:url sessionConfiguration:config];
    } else {
        manager = [[self alloc] initWithSessionConfiguration:config];
    }
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    [manager setSecurityPolicy:securityPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    // 以JSON格式解析参数
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 以HTTP格式返回
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 超时时间
    manager.requestSerializer.timeoutInterval = 15.0f;
    
    // 多线程并发访问网络
    dispatch_queue_t workQueue = dispatch_queue_create("com.ichensheng.network", DISPATCH_QUEUE_CONCURRENT);
    manager.completionQueue = workQueue;
    return manager;
}

/**
 *  取消所有网络访问
 */
- (void)cancelAllRequest {
    [self.operationQueue cancelAllOperations];
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        [dataTasks performSelector:@selector(cancel)];
        [uploadTasks performSelector:@selector(cancel)];
        [downloadTasks performSelector:@selector(cancel)];
    }];
}

@end
