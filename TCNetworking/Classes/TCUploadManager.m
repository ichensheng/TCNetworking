//
//  TCUploadManager.m
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/23.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCUploadManager.h"

static NSString * const kProgressCallbackKey = @"progressCallback";
static NSString * const kSuccessCallbackKey = @"successCallback";
static NSString * const kFailureCallbackKey = @"failureCallback";
static NSString * const kProgressKey = @"progress";

@interface TCUploadManager()

@property (nonatomic, strong) NSOperationQueue *uploadQueue;
@property (nonatomic, strong) dispatch_queue_t barrierQueue;
@property (nonatomic, strong) NSMutableDictionary *URLCallbacks;
@property (nonatomic, strong) NSMutableDictionary *URLProgresses;

@end

@implementation TCUploadManager

- (instancetype)init {
    if (self = [super init]) {
        _uploadQueue = [[NSOperationQueue alloc] init];
        [_uploadQueue setMaxConcurrentOperationCount:2];
        _URLCallbacks = [[NSMutableDictionary alloc] init];
        _URLProgresses = [[NSMutableDictionary alloc] init];
        _barrierQueue = dispatch_queue_create("com.ichensheng.network.upload.TCBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

/**
 *  设置上传的最大并发数
 *
 *  @param maxConcurrentUploads 上传最大并发数
 */
- (void)setMaxConcurrentUploads:(NSInteger)maxConcurrentUploads {
    self.uploadQueue.maxConcurrentOperationCount = maxConcurrentUploads;
}

/**
 *  当前的上传数
 *
 *  @return 上传数
 */
- (NSUInteger)currentUploadCount {
    return self.uploadQueue.operationCount;
}

/**
 *  获取当前最大的上传并发数
 *
 *  @return 最大的上传并发数
 */
- (NSInteger)maxConcurrentUploads {
    return self.uploadQueue.maxConcurrentOperationCount;
}

/**
 *  取消所有上传任务
 */
- (void)cancelAllUpload {
    [self.uploadQueue cancelAllOperations];
}

/**
 *  上传文件
 *
 *  @param fileURL   文件路径
 *  @param serverURL 上传地址
 *  @param progress  进度回调
 *  @param success   成功回调
 *  @param failure   失败回调
 *
 *  @return TCUploadOperation对象
 */
- (TCUploadOperation *)uploadFile:(NSString *)fileURL
                        serverURL:(NSString *)serverURL
                         progress:(TCUploadProgressBlock)progress
                          success:(TCUploadSuccessBlock)success
                          failure:(TCUploadFailureBlock)failure {
    
    __block TCUploadOperation *operation;
    NSURL *url = [NSURL fileURLWithPath:fileURL];
    @weakify(self)
    [self addProgressCallback:progress success:success failure:failure forURL:url create:^{
        @strongify(self)
        operation = [[TCUploadOperation alloc] initWithURL:fileURL serverURL:serverURL progress:^(NSUInteger total, NSUInteger completed) {
            @strongify(self)
            if (!self) {
                return;
            }
            __block NSArray *callbacksForURL;
            __block NSMutableArray *progressesArray;
            dispatch_sync(self.barrierQueue, ^{
                callbacksForURL = [self.URLCallbacks[url] copy];
                progressesArray = self.URLProgresses[url];
            });
            for (NSDictionary *callbacks in callbacksForURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TCUploadProgressBlock callback = callbacks[kProgressCallbackKey];
                    if (callback) {
                        callback(total, completed);
                    }
                });
            }
            // 记住下载进度
            progressesArray[0] = @(total);
            progressesArray[1] = @(completed);
        } success:^(NSURLResponse *response, id responseObject) {
            @strongify(self)
            if (!self) {
                return;
            }
            __block NSArray *callbacksForURL;
            dispatch_barrier_sync(self.barrierQueue, ^{
                callbacksForURL = [self.URLCallbacks[url] copy];
            });
            for (NSDictionary *callbacks in callbacksForURL) {
                TCUploadSuccessBlock callback = callbacks[kSuccessCallbackKey];
                if (callback) {
                    callback(response, responseObject);
                }
            }
            [self doneForURL:url];
        } failure:^(NSURLResponse *response, NSError *error) {
            @strongify(self)
            if (!self) {
                return;
            }
            __block NSArray *callbacksForURL;
            dispatch_barrier_sync(self.barrierQueue, ^{
                callbacksForURL = [self.URLCallbacks[url] copy];
            });
            for (NSDictionary *callbacks in callbacksForURL) {
                TCUploadFailureBlock callback = callbacks[kFailureCallbackKey];
                if (callback) {
                    callback(response, error);
                }
            }
            [self doneForURL:url];
        } cancel:^{
            @strongify(self)
            if (!self) {
                return;
            }
            [self doneForURL:url];
        }];
        operation.client = self.client;
        [self.uploadQueue addOperation:operation];
    }];
    return operation;
}

- (void)addProgressCallback:(TCUploadProgressBlock)progress
                    success:(TCUploadSuccessBlock)success
                    failure:(TCUploadFailureBlock)failure
                     forURL:(NSURL *)url
                     create:(void(^)())create {
    
    // 上传的文件路径如果为空则直接返回
    if (url == nil) {
        if (success != nil) {
            success(nil, nil);
        }
        return;
    }
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        BOOL first = NO;
        if (!self.URLCallbacks[url]) {
            self.URLCallbacks[url] = [[NSMutableArray alloc] init];
            
            NSMutableArray *progressesArray = [[NSMutableArray alloc] init];
            [progressesArray addObject:@(0)]; // total
            [progressesArray addObject:@(0)]; // completed
            self.URLProgresses[url] = progressesArray;
            
            first = YES;
        }
        
        // 一个URL只有一个上传，对应多个回调响应
        NSMutableArray *callbacksForURL = self.URLCallbacks[url];
        NSMutableDictionary *callbacks = [[NSMutableDictionary alloc] init];
        if (progress) { // 进度回调
            if (!first) { // 后面启动的下载立即获取最新进度
                NSMutableArray *progressesArray = self.URLProgresses[url];
                progress([progressesArray[0] integerValue], [progressesArray[1] integerValue]);
            }
            callbacks[kProgressCallbackKey] = [progress copy];
        }
        if (success) { // 上传成功回调
            callbacks[kSuccessCallbackKey] = [success copy];
        }
        if (failure) { // 上传失败回调
            callbacks[kFailureCallbackKey] = [failure copy];
        }
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[url] = callbacksForURL;
        
        if (first) {
            create();
        }
    });
}

/**
 *  下载完成
 *
 *  @param URL 下载地址
 */
- (void)doneForURL:(NSURL *)URL {
    [self.URLCallbacks removeObjectForKey:URL];
    [self.URLProgresses removeObjectForKey:URL];
}

@end