//
//  TCFileUploader.h
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/23.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCBaseAPIClient.h"

typedef void (^TCUploadProgressBlock)(NSUInteger total, NSUInteger completed);
typedef void (^TCUploadSuccessBlock)(NSURLResponse *response, NSString *responseString);
typedef void (^TCUploadFailureBlock)(NSURLResponse *response, NSError *error);
typedef void (^TCUploadCancelBlock)();

@interface TCFileUploader : NSObject

/**
 *  一次上传多个文件
 *
 *  @param fileURLs  文件路径数组
 *  @param serverURL 上传地址
 *  @param progress  上传进度
 *  @param success   成功回调
 *  @param failure   失败会掉
 *  @param client    TCBaseAPIClient
 *
 *  @return NSURLSessionUploadTask
 */
+ (NSURLSessionUploadTask *)uploadFiles:(NSArray *)fileURLs
                              serverURL:(NSString *)serverURL
                               progress:(TCUploadProgressBlock)progress
                                success:(TCUploadSuccessBlock)success
                                failure:(TCUploadFailureBlock)failure
                              useClient:(TCBaseAPIClient *)client;

/**
 *  上传文件
 *
 *  @param fileURL   文件路径
 *  @param serverURL 上传地址
 *  @param progress  上传进度
 *  @param success   成功回调
 *  @param failure   失败会掉
 *  @param client    TCBaseAPIClient
 *
 *  @return NSURLSessionUploadTask
 */
+ (NSURLSessionUploadTask *)uploadFile:(NSString *)fileURL
                             serverURL:(NSString *)serverURL
                              progress:(TCUploadProgressBlock)progress
                               success:(TCUploadSuccessBlock)success
                               failure:(TCUploadFailureBlock)failure
                             useClient:(TCBaseAPIClient *)client;

@end
