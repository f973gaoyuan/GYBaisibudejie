//
//  AFHTTPSessionManager+Manager.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/17.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "AFHTTPSessionManager+Manager.h"

@implementation AFHTTPSessionManager (Manager)
+ (instancetype)gy_manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/x-javascript", nil];
    manager.responseSerializer = response;
    return manager;
}


@end
