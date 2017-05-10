//
//  TCDownloadManager.h
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/23.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCDownloadOperation.h"

@interface TCDownloadManager : NSObject

@property (nonatomic, strong) TCBaseAPIClient *client;

/**
 *  设置下载的最大并发数
 *
 *  @param maxConcurrentDownloads 下载最大并发数
 */
- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads;

/**
 *  当前的下载数
 *
 *  @return 下载数
 */
- (NSUInteger)currentDownloadCount;

/**
 *  获取当前最大的下载并发数
 *
 *  @return 最大的下载并发数
 */
- (NSInteger)maxConcurrentDownloads;

/**
 *  取消所有下载任务
 */
- (void)cancelAllDownload;

/**
 * 指定URL取消一个下载
 *
 * @param URLString 文件地址
 */
- (void)cancelDownload:(NSString *)URLString;

/**
 *  判断某个文件是否正在下载
 *
 *  @param url 文件地址
 *
 *  @return 返回是否在下载
 */
- (BOOL)checkDownloadingWithURL:(NSURL *)url;

/**
 *  下载文件
 *
 *  @param URLString   下载路径
 *  @param progress    进度回调
 *  @param destination 存储路径
 *  @param success     成功回调
 *  @param failure     失败回调
 *
 *  @return TCDownloadOperation对象
 */
- (TCDownloadOperation *)downloadFile:(NSString *)URLString
                             progress:(TCDownloadProgressBlock)progress
                          destination:(TCDownloadDestinationBlock)destination
                              success:(TCDownloadSuccessBlock)success
                              failure:(TCDownloadFailureBlock)failure;

@end
