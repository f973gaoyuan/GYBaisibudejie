//
//  GYFriendTrendViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/12.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYFriendTrendViewController.h"


#import "../View/GYRecommendFriendCell.h"


static NSString *recommendID = @"recommendCell";
static NSString *selectedID = @"selectedCell";

@interface GYFriendTrendViewController ()
@property (weak, nonatomic) NSArray<GYRecommendFriendItem*> *recommendFriends;
@end

@implementation GYFriendTrendViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self setupNavBar];
    
    GYNetworkingManager *manager = [GYNetworkingManager shareManager];
    // 获取朋友推荐数据
    [manager requestFriendRecommendData:^(NSArray *recommendFriends, NSError *error) {
        self.recommendFriends = recommendFriends;
        [self.tableView reloadData];
    }];
    // 获取关注朋友帖子
    [manager requestFriendTopicData:^(NSArray *friendTopics, NSError *error) {
#warning 功能未实现
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYRecommendFriendCell class]) bundle:nil] forCellReuseIdentifier:recommendID];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}

- (void)setupNavBar {
    self.navigationItem.title = @"我的关注";
    
    //左
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"]
                           highlightedImage:[UIImage imageNamed:@"friendsRecommentIcon-click"]
                                     target:self
                                     action:@selector(recommondClick)];
    
}

- (void)recommondClick {
    GYLog(@"recommondClick");
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        GYRecommendFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendID];
        cell.recommendFriends = _recommendFriends;
        return cell;

    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedID];
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:selectedID];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 100;
    if(indexPath.row == 0) {
        height = GYScreenH * 150.0 / 736;
    }
    return height;
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
