//
//  GYTabBarController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/12.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYTabBarController.h"

#import "../../LoginRegister(登录&注册)/Controller/GYLoginRegisterVC.h"

#import "../../Essence(精华)/Controller/GYEssenceViewController.h"
#import "../../FriendTrend(关注)/Controller/GYFriendTrendViewController.h"
#import "../../Me(我)/Controller/GYMeViewController.h"
#import "../../New(新帖)/Controller/GYNewViewController.h"
#import "../../Publish(发布)/Controller/GYPublishViewController.h"

#import "../../Other/Category/UIImage+Render.h"

#import "GYNavigationController.h"
/*
 封装：谁的事情谁管理，让业务逻辑非常清晰
 */

@interface GYTabBarController ()
@property (weak, nonatomic) UIButton *plusBtn;
@end
/*
 问题：
 1. 选中按钮的图片被渲染 -> iOS7之后默认tabBar上按钮图片都会被渲染(tintColor) 1.修改图片 2.通过代码 ✅
 2. 选中按钮的标题色：黑色 标题字体大小 -> 对应子控制器的tabbarItem
 3. 发布按钮显示不出来：图片被渲染
    中加图片问什么会被渲染？ --->  中间图片太大，系统会自动渲染
 */
@implementation GYTabBarController
- (UIButton *)plusBtn {
    if(_plusBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon_49x49_"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon_49x49_"] forState:UIControlStateHighlighted];
        [btn sizeToFit];
        [self.tabBar addSubview:btn];
        
        [btn addTarget:self action:@selector(newestClick) forControlEvents:UIControlEventTouchUpInside];
        
        _plusBtn = btn;
    }
    return _plusBtn;
}

- (void)newestClick {
    //GYLoginRegisterVC *loginVC = [[GYLoginRegisterVC alloc] init];
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //GYNavigationController *nav = [[GYNavigationController alloc] initWithRootViewController:loginVC];
//    [self presentViewController:nav animated:YES completion:^{
//    }];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GYLoginRegisterVC" bundle:nil];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:nil];
}

+ (void)load {
    // 获取那个类中UITabBarItem
    //UITabBarItem *item = [UITabBarItem appearance];
    //UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
    
    //设置按钮选中标题颜色：富文本：描述一个文字颜色、字体、阴影、空心、图文混排
    //创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    //设置字体x尺寸：只有设置正常状态下，才会有效果
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    //attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrsNor[NSFontAttributeName] = [UIFont italicSystemFontOfSize:12];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
    /*
     appearance
     1. 谁可以使用appearance： 必须准守UIAppearance协议，实现协议方法
     2. 使用appearance， 可以设置任何属性吗？ --> NO 不可以
     2.1 那么那些属性可以通过appearance设置，只有带有“”宏的属性或方法，才可以通过appearance调用
     3. 如果想通过appearance设置属性，必须要在显示之前设置
     */
}

//+ (void)initialize
//{
//    if (self == [GYTabBarController class]) {
//
//    }
//}
/*
 系统的UITabBarButttonItem什么时候添加的 并不是在viewDidLoad添加的 是在viewWillAppear中添加的。。。
 因为在viewWillAppear 中时候打印self.tabBar 的子控件是后已经加载
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tabBar.tintColor = [UIColor blackColor]; //设置渲染颜色 -- 这种方法也行
    // 创建发布按钮
    self.plusBtn.center = CGPointMake(self.tabBar.bounds.size.width * 0.5, self.tabBar.bounds.size.height * 0.5);

    // 添加所有子控制器
    [self addAllChildVC];
    
    [self setupAllTitleButton];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    GYLog(@"%@", self.tabBar.subviews);
//}
#pragma mark - 添加所有子控制器
- (void)addAllChildVC {
    //1.精华
    GYEssenceViewController *essenceVC = [[GYEssenceViewController alloc] init];
    GYNavigationController *nav1 = [[GYNavigationController alloc] initWithRootViewController:essenceVC];
    [self addChildViewController:nav1];
    
    //2.新帖
    GYNewViewController *newVC = [[GYNewViewController alloc] init];
    GYNavigationController *nav2 = [[GYNavigationController alloc] initWithRootViewController:newVC];
    [self addChildViewController:nav2];
    
    //3.发布
    GYPublishViewController *publishVC = [[GYPublishViewController alloc] init];
    [self addChildViewController:publishVC];
    
    //4.关注
    GYFriendTrendViewController *ftVC = [[GYFriendTrendViewController alloc] init];
    GYNavigationController *nav3 = [[GYNavigationController alloc] initWithRootViewController:ftVC];
    [self addChildViewController:nav3];
    
    //5.我
    //GYMeViewController *meVC = [[GYMeViewController alloc] init];
    //GYNavigationController *nav4 = [[GYNavigationController alloc] initWithRootViewController:meVC];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GYMeViewController" bundle:nil];
    GYNavigationController *nav4 = [[GYNavigationController alloc] initWithRootViewController:[storyboard instantiateInitialViewController]];
    [self addChildViewController:nav4];
}

- (void)setupAllTitleButton{
    UIViewController *vc;
    
//    vc = self.childViewControllers[0];
//    vc.tabBarItem.title = @"精华";
//    vc.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
//    vc.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];
    UINavigationController *nav = self.childViewControllers[0];
    vc = nav.childViewControllers[0];
    vc.tabBarItem.title = @"首页";
    vc.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon_27x27_"];
    vc.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon_27x27_"];
    //以上两种方法设置都行，但是下面的方法光设title 是没有效果的必须同时设置图片才会有效果
    //所以最好找 tabBar的直接子控制器设置比较靠谱

    vc = self.childViewControllers[1];
    vc.tabBarItem.title = @"社区";
    vc.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon_27x27_"];
    vc.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon_27x27_"];

    vc = self.childViewControllers[2];
    //publishVC = @"发布";
    //vc.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_publish_icon"];
    //vc.tabBarItem.selectedImage =[UIImage imageOriginalWithName:@"tabBar_publish_click_icon"];
    //vc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    vc.tabBarItem.enabled = NO;

    vc = self.childViewControllers[3];
    vc.tabBarItem.title = @"关注";
    vc.tabBarItem.image = [UIImage imageNamed:@"tabBar_new_icon_27x27_"];
    vc.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_new_click_icon_27x27_"];

    vc = self.childViewControllers[4];
    vc.tabBarItem.title = @"我的";
    vc.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon_27x27_"];
    vc.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_me_click_icon_27x27_"];
    /*
     问题：
     1.选中的图片被渲染
     2.选中标题颜色: 黑色 标题字体大
     3.发布按钮显示不出来
     */
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
