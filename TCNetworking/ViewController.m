//
//  ViewController.m
//  TCNetworking
//
//  Created by 陈 胜 on 16/6/12.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "ViewController.h"
#import "TCBatchRequestManager.h"
#import "TCCommAPIClient.h"
#import "TCNetworkingHelper.h"
#import "TCSerialRequestManager.h"

@interface ViewController ()

@property (nonatomic, strong) TCBatchRequestManager *batchRequestManager;
@property (nonatomic, strong) TCSerialRequestManager *requestManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TCBatchRequest *request1 = [TCBatchRequest POST:@"http://www.baidu.com" parameters:nil];
    TCBatchRequest *request2 = [TCBatchRequest GET:@"http://www.qq.com" parameters:nil];
    TCBatchRequest *request3 = [TCBatchRequest GET:@"http://www.sina.com" parameters:nil];
    self.batchRequestManager = [[TCBatchRequestManager alloc] initWithSuccessBlock:^(NSDictionary *successResponses) {
    } failure:^(NSDictionary *errorResponses) {
    } serial:NO useClient:[TCCommAPIClient sharedInstance]];
    [self.batchRequestManager addBatchRequests:@[request1, request2, request3]];
    [self.batchRequestManager startRequest];
    
    
    self.requestManager =
    [TCSerialRequestManager instanceWithClient:[TCCommAPIClient sharedInstance]];
    [self.requestManager POST:@"http://www.baidu.com" parameters:nil success:^(NSString *responseString) {
        NSLog(@"请求baidu成功");
    } failure:^(NSError *error) {
        NSLog(@"请求baidu失败");
    }];
    
    [self.requestManager GET:@"http://www.qq.com" parameters:nil success:^(NSString *responseString) {
        NSLog(@"请求QQ成功");
    } failure:^(NSError *error) {
        NSLog(@"请求QQ失败");
    }];
    
    [self.requestManager GET:@"http://www.sina.com" parameters:nil success:^(NSString *responseString) {
        NSLog(@"请求sina成功");
    } failure:^(NSError *error) {
        NSLog(@"请求sina失败");
    }];
}

@end
