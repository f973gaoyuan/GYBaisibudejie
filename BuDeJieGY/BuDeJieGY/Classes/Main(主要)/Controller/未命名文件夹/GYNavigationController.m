//
//  GYNavigationController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/14.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYNavigationController.h"
#import "../View/GYNavigationBar.h"
#import "../View/GYBackBtn.h"

@implementation UIViewController (BackButtonHandler)

@end
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////
@interface GYNavigationController () <UIGestureRecognizerDelegate>

@end
/*
 滑动返回功能： 导航控制器iOS7后自带
 恢复滑动返回功能：
 分析： 覆盖掉系统滑动返回按钮， 滑动返回失效
 需求既要覆盖系统返回按钮，也要有滑动返回功能
 
 当覆盖返回按钮是，系统额外做了一些事情，导致滑动返回功能失效
 
 类生命中找到 interactivePopGestureRecognizer 属性，感觉此属性可能就是返回滑动手势
 验证：
    取消自定义返回设置，系统会默认设置返回按钮
    self.interactivePopGestureRecognizer.delegate = self;
    遵守<UIGestureRecognizerDelegate>协议
    实现代理方法gestureRecognizer:shouldReceiveTouch:
    把方该法的返回值设成NO
    发现滑动返回失效
 */
@implementation GYNavigationController

+ (void)load {
    /*
     appearance 是获取整个应用程序下所有的东西
     appearanceWhenContainedInInstancesOfClasses：获取那个类下的的东西
     iOS下使用appearance 修改短信界面，导致联系人黑屏
     */
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    [bar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
    
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //***********************
    //去掉系统的返回手势添加自己的，但是要使用系统自带手势的action
    //GYLog(@"%@", self.interactivePopGestureRecognizer);
    /*  <UIScreenEdgePanGestureRecognizer: 0x7fd004d16770;
     state = Possible;
     delaysTouchesBegan = YES;
     view = <UILayoutContainerView 0x7fd004d02020>;
     target= <(action=handleNavigationTransition:,
     target=<_UINavigationInteractiveTransition 0x7fd004d15fd0>)>>
     */
    
    //GYLog(@"%@", self.interactivePopGestureRecognizer.delegate);
    /*
    <_UINavigationInteractiveTransition: 0x7f9f12f06690>
    */
    // 屏蔽系统手势
    self.interactivePopGestureRecognizer.enabled = NO;
    id target = self.interactivePopGestureRecognizer.delegate;
    // 添加手势到导航控制器的view 实现任何区域都可滑动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target
                                                                          action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    //***********************
    GYNavigationBar *bar = [[GYNavigationBar alloc] init];
    //bar.barStyle = 
    [self setValue:bar forKey:@"navigationBar"];
}
#pragma mark -UIGestureRecognizerDelegate
// 控制手势是否触发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 跟控制器View不能滑动，会造成假死状态
    return (self.childViewControllers.count > 1);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 设置系统滑动手势代理为自己
    //self.interactivePopGestureRecognizer.delegate = self;
    // 清空手势代理，不让它把滑动返回失效
    self.interactivePopGestureRecognizer.delegate = nil;
    if(self.childViewControllers.count > 0) {
        GYBackBtn *btn = [GYBackBtn backBtnWithImage:[UIImage imageNamed:@"navigationButtonReturnN_15x21_"]
                                        highlightImage:[UIImage imageNamed:@"navigationButtonReturnClickN_15x21_"]
                                                 title:@"返回"
                                                target:self
                                                action:@selector(back)];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];

        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        //UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        //UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        //viewController.navigationItem.leftBarButtonItems = @[spaceItem, btnItem];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    BOOL shouldPop = YES;
    id vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }

    if(shouldPop) {
        [self popViewControllerAnimated:YES];
    }
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
