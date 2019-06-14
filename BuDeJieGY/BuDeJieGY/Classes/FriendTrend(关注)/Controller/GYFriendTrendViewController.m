//
//  GYFriendTrendViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/12.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYFriendTrendViewController.h"

#import "../Model/GYRecommendFriendItem.h"

#import "../View/GYRecommendFriendCell.h"


static NSString *recommendID = @"recommendCell";
static NSString *selectedID = @"selectedCell";

@interface GYFriendTrendViewController ()
@property (strong, nonatomic) NSArray<GYRecommendFriendItem*> *recommendFriends;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation GYFriendTrendViewController

- (AFHTTPSessionManager *)manager {
    if(_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self setupNavBar];
    
    [GYRecommendFriendItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID":@"id"};
    }];
    
    // 获取朋友推荐数据
    [self loadFriendRecommend];
    
    [self loadListData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYRecommendFriendCell class]) bundle:nil] forCellReuseIdentifier:recommendID];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
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

#pragma mark - 获取朋友推荐数据
//friend recommend
- (void)loadFriendRecommend {
    NSString *urlStr = @"http://d.api.budejie.com/user/friend_recommend/bsbdjhd-iphone-5.0.9/6-last_coord-list/";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        self.recommendFriends = [GYRecommendFriendItem mj_objectArrayWithKeyValuesArray:responseObject[@"hot_list"]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GYLog(@"------%@", error);
    }];
}

#pragma mark - 获取精选帖子

- (void)loadListData {
    NSString *urlStr = @"http://d.api.budejie.com/topic/list/jingxuan/attention/bsbdjhd-iphone-5.0.9/0-20.json";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        
        [responseObject writeToFile:@"/Users/gaoyuan/Desktop/GIT/f973gaoyuan/ListData.plist" atomically:YES];
        NSArray *array = responseObject[@"list"];
        NSDictionary *dist = array[2];
        //[dist createProperyCode:dist];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GYLog(@"------%@", error);
    }];
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
