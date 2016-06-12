//
//  TCBaseAPIClient.h
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/23.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**
 *  打破block循环引用，使用方法:
 *  @weakify(self)
 *  [self doSomething^{
 *      @strongify(self)
 *      if (!self) {
 *          return;
 *      }
 *      // ...
 *  }];
 */
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif
#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

@interface TCBaseAPIClient : AFHTTPSessionManager

/**
 *  通过base url创建网络访问对象
 *
 *  @param url api基路径
 *
 *  @return TCBaseAPIClient
 */
+ (instancetype)clientWithBaseURL:(NSURL *)url;

/**
 *  取消所有网络访问
 */
- (void)cancelAllRequest;

@end
