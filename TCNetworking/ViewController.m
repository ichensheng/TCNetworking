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

@interface ViewController ()

@property (nonatomic, strong) TCBatchRequestManager *batchRequestManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TCBatchRequest *request1 = [TCBatchRequest POST:@"http://www.baidu.com" parameters:nil];
    TCBatchRequest *request2 = [TCBatchRequest GET:@"http://www.qq.com" parameters:nil];
    TCBatchRequest *request3 = [TCBatchRequest GET:@"http://www.sina.com" parameters:nil];
    self.batchRequestManager = [[TCBatchRequestManager alloc] initWithSuccessBlock:^(NSDictionary *successResponses) {
        NSLog(@"%@", successResponses);
    } failure:^(NSDictionary *errorResponses) {
        NSLog(@"%@", errorResponses);
    } useClient:[TCCommAPIClient sharedInstance]];
    [self.batchRequestManager addBatchRequests:@[request1, request2, request3]];
    [self.batchRequestManager startRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
