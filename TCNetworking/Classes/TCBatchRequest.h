//
//  TCBatchRequest.h
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/26.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCBatchRequest : NSObject

@property (nonatomic, strong, readonly) NSString *URLString;
@property (nonatomic, copy, readonly) NSDictionary *parameters;

/**
 *  构造批量请求对象
 *
 *  @param URLString  请求URL
 *  @param parameters 请求参数
 *
 *  @return TCBatchRequest
 */
- (instancetype)initWithURL:(NSString *)URLString
                 parameters:(NSDictionary *)parameters;

@end
