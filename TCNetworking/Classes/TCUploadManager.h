//
//  TCUploadManager.h
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/23.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCUploadOperation.h"

@interface TCUploadManager : NSObject

@property (nonatomic, strong) TCBaseAPIClient *client;

/**
 *  设置上传的最大并发数
 *
 *  @param maxConcurrentUploads 上传最大并发数
 */
- (void)setMaxConcurrentUploads:(NSInteger)maxConcurrentUploads;

/**
 *  当前的上传数
 *
 *  @return 上传数
 */
- (NSUInteger)currentUploadCount;

/**
 *  获取当前最大的上传并发数
 *
 *  @return 最大的上传并发数
 */
- (NSInteger)maxConcurrentUploads;

/**
 *  取消所有上传任务
 */
- (void)cancelAllUpload;

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
                          failure:(TCUploadFailureBlock)failure;

@end
