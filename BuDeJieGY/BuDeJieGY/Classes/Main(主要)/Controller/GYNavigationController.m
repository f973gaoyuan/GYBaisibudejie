//
//  GYNavigationController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/31.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYNavigationController.h"

@interface GYNavigationController ()

@end

@implementation GYNavigationController

+ (void)load {
    /*
     appearance 是获取整个应用程序下所有的东西
     appearanceWhenContainedInInstancesOfClasses：获取那个类下的的东西
     iOS下使用appearance 修改短信界面，导致联系人黑屏
     */
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    [bar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:19]}];
    //[bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:1 alpha:0.99]] forBarMetrics:UIBarMetricsDefault];
    //[bar setBackgroundImage:[UIImage imageWithColor:GYAlphaColor(0.99, 200, 180, 180)] forBarMetrics:UIBarMetricsDefault];
    //[bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backButtonImage = [UIImage imageOriginalWithName:@"nav_back_item_gray_21x21_"];
    self.backButtonTitle = @"返回";
    self.fullScreenPopGestureEnabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
