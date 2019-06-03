//
//  GYEssenceViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/12.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYEssenceViewController.h"

@interface GYEssenceViewController ()

@end

@implementation GYEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    // 设置导航条 =》由栈顶控制器的navgationItem决定
    [self setupNavBar];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
