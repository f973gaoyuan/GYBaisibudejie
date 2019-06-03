//
//  AppDelegate.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/11.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "AppDelegate.h"
#import "../AD(广告)/Controller/GYADViewController.h"

#warning 上线时记得修改
#ifdef DEBUG
#import "../Main(主要)/Controller/GYTabBarController.h"
#endif

/*
 优先级：LauchScreen > LauchImage
 在xcode配置后，不起作用 1.清空xcode缓存 2.直接删掉模拟器中的程序重新运行
 如果是通过LauchImage设置启动界面，那么屏幕的可视范围有图片决定
 注意：如果使用LauchImage，必须让你的美工提供各种尺寸的启动图片
 
 LaunchScreen：xcode6开始才有
 LaunchScreen好处：1.自动识别当前真机或者模拟器的尺寸 2.只要让美工提供一个可拉伸图片
 3.展示更多东西
 
 LauchScreen底层实现：把LaunchScreen截屏，并生成一张图片，作为启动界面
 */

/*
 项目架构(结构)搭建：主流结构(UITabBarController + 导航控制器)
 -> 项目开发方式 1.storyboard 2.纯代码
 */

/*
 广告界面：
 1. 把一个view添加到窗口上，过段时间移除
 2. 一开始就设置窗口的跟控制器为广告界面
 */

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //2.设置窗口根控制器
#warning TODO: online change 上线时记得修改
#ifdef DEBUG
    GYTabBarController *tabBarVC = [[GYTabBarController alloc] init];
    self.window.rootViewController = tabBarVC;
#else
    GYADViewController *adVC = [[GYADViewController alloc] init];
    self.window.rootViewController = adVC;
#endif

    //3.显示窗口
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
