//
//  GYNavigationController.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/14.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface GYNavigationController : UINavigationController

@end

NS_ASSUME_NONNULL_END
