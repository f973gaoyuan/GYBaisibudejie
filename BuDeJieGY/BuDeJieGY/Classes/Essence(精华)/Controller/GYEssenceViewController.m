//
//  GYEssenceViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/5.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYEssenceViewController.h"

#import "ChildVC/GYRecommendVC.h"
#import "ChildVC/GYVideoVC.h"
#import "ChildVC/GYPictureVC.h"
#import "ChildVC/GYJokeVC.h"
#import "ChildVC/GYEntertainmentVC.h"
#import "ChildVC/GYGameVC.h"

@interface GYEssenceViewController ()

@end

@implementation GYEssenceViewController

- (void)viewDidLoad {
    self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    
    [self setupAllViewController];
}

- (void)setupNavBar {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    //
    
    //左
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"nav_item_game_icon"]
                           highlightedImage:[UIImage imageNamed:@"nav_item_game_click_icon"]
                                     target:self
                                     action:@selector(gameClick)];
    
    // 右
    self.navigationItem.rightBarButtonItem =
    [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"navigationButtonRandom"]
                           highlightedImage:[UIImage imageNamed:@"navigationButtonRandomClick"]
                                     target:self
                                     action:@selector(randomClick)];
}

- (void)gameClick {
    GYLog(@"gameClick");
}

- (void)randomClick {
    GYLog(@"randomClick");
}

#pragma mark - 设置内容视图控制器
- (void)setupAllViewController {
    GYRecommendVC *recVC = [[GYRecommendVC alloc] init];
    recVC.title = @"推荐";
    [self addChildViewController:recVC];
    //--------
    GYVideoVC *videoVC = [[GYVideoVC alloc] init];
    videoVC.title = @"视频";
    [self addChildViewController:videoVC];
    //--------
    GYPictureVC *pictureVC = [[GYPictureVC alloc] init];
    pictureVC.title = @"图片";
    [self addChildViewController:pictureVC];
    //--------
    GYJokeVC *jokeVC = [[GYJokeVC alloc] init];
    jokeVC.title = @"笑话";
    [self addChildViewController:jokeVC];
    //--------
    GYEntertainmentVC *entertainmentVC = [[GYEntertainmentVC alloc] init];
    entertainmentVC.title = @"娱乐";
    [self addChildViewController:entertainmentVC];
    //--------
    GYGameVC *gameVC = [[GYGameVC alloc] init];
    gameVC.title = @"游戏";
    [self addChildViewController:gameVC];
    
    //    for(NSInteger i = 0; i < self.childViewControllers.count; i++) {
    //        [self setupViewWithIndex:i];
    //    }
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
