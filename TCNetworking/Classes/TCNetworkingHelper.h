//
//  TCNetworkingHelper.h
//  TCNetworking
//
//  Created by 陈 胜 on 16/5/23.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCNetworkingHelper : NSObject

/**
 *  解析后台返回的数据
 *
 *  @param responseObject 后台返回数据
 *
 *  @return 返回解析之后的字符串数据
 */
+ (NSString *)parseResponse:(id)responseObject;

@end
