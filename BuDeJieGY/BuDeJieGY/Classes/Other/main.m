//
//  main.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/11.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/*
 1. 创建UIApplication对象(1.打开网页、发短信和打电话 2.设置应用程序提醒数字 3.设置联网状态 4设置状态栏)
 2. 创建AppDelegate代理对象，并且成为UIApplication的代理，(监听整个app生命周期，处理内存警告)
 3. 开启主运行循环，保证应用程序一直运行(runloop：每个线程都有runloop，主线程有一个runloop是自动开启的)
 4. 加载info.plist，判断是否指定了main.storyboard，如果指定，就去加载
 
 加载Main.storyboard
 1. 创建窗口(OpenGL)
 2. 设置窗口跟控制器,并且设置
 3. 显示窗口
 */

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
