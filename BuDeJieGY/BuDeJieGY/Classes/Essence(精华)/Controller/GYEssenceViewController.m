//
//  GYEssenceViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/5.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYEssenceViewController.h"

#import "ChildVC/GYTopicVC.h"
#import "ChildVC/GYEntertainmentVC.h"

@interface GYEssenceViewController ()

@end

@implementation GYEssenceViewController

- (void)viewDidLoad {
    //self.navigationController.navigationBarHidden = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //[self setupNavBar];
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        *norColor = [UIColor lightGrayColor];
        *selColor = [UIColor blackColor];
    }];
    
    // 设置标题高度、字体
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        
        CGFloat titleH = 44;
        CGFloat fontH = 0.409 * titleH;
        
        *titleScrollViewColor = [UIColor colorWithWhite:1 alpha:0.9];
        
        *titleHeight = titleH;
        *titleFont = [UIFont systemFontOfSize:fontH];
    }];
    
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor, CGFloat *underLineEqualTitleWidthScale) {
        *underLineColor = [UIColor redColor];
        *underLineEqualTitleWidthScale = 0.4;
    }];
    
    [self setUpTitleScale:^(CGFloat *titleScale) {
        *titleScale = 1.1;
    }];
    
//    [self setUpCoverEffect:^(UIColor **coverColor, CGFloat *coverCornerRadius) {
//        
//        // 设置蒙版颜色
//        *coverColor = [UIColor colorWithWhite:0.7 alpha:0.4];
//        
//        // 设置蒙版圆角半径
//        *coverCornerRadius = 13;
//    }];
    
    self.isfullScreen = YES;    // 全屏模式
    self.dragingFollow = YES;   // 标题跟随拖动保持居中

}

#pragma mark - 设置内容视图控制器
- (void)setUpAllViewController {
    GYTopicVC *recVC = [[GYTopicVC alloc] init];
    recVC.title = @"推荐";
    recVC.dataType = GYEssenceNetDataTypeRecommend;
    [self addChildViewController:recVC];
    //--------
    GYTopicVC *videoVC = [[GYTopicVC alloc] init];
    videoVC.title = @"视频";
    videoVC.dataType = GYEssenceNetDataTypeVideo;
    [self addChildViewController:videoVC];
    //--------
    GYTopicVC *pictureVC = [[GYTopicVC alloc] init];
    pictureVC.title = @"图片";
    pictureVC.dataType = GYEssenceNetDataTypePicture;
    [self addChildViewController:pictureVC];
    //--------
    GYTopicVC *jokeVC = [[GYTopicVC alloc] init];
    jokeVC.title = @"笑话";
    jokeVC.dataType = GYEssenceNetDataTypeJoke;
    [self addChildViewController:jokeVC];
    //--------
    GYEntertainmentVC *entertainmentVC = [[GYEntertainmentVC alloc] init];
    entertainmentVC.title = @"娱乐";
    [self addChildViewController:entertainmentVC];
    //--------
}

@end
