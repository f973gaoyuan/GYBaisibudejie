//
//  GYStatusWindow.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/27.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYStatusWindow.h"

static GYStatusWindow *_statusWindow = nil;

@implementation GYStatusWindow
+ (instancetype)show {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _statusWindow = [[GYStatusWindow alloc] initWithFrame:CGRectMake(0, 0, GYScreenW, 20)];
        _statusWindow.windowLevel = UIWindowLevelAlert;
        _statusWindow.backgroundColor = [UIColor clearColor];
        _statusWindow.rootViewController = [[UIViewController alloc] init];
        _statusWindow.hidden = NO;
    });
    return _statusWindow;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITableView *tableView = [[UIApplication sharedApplication].keyWindow fetchChildView];
    if(tableView) {
        [tableView setContentOffset:CGPointMake(0, -tableView.contentInset.top) animated:YES];
    }
}

@end
