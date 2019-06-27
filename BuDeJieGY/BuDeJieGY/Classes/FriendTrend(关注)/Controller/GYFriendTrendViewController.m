//
//  GYFriendTrendViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/12.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYFriendTrendViewController.h"


#import "../View/GYRecommendFriendCell.h"

#import "../../Essence(精华)/VM/GYTopicCellMode.h"
#import "../../Essence(精华)/View/GYCoverView.h"
#import "../../Essence(精华)/View/GYTopicCell.h"

#import <MJRefresh/MJRefresh.h>

static NSString *recommendID = @"recommendCell";
static NSString *selectedID = @"selectedCell";

@interface GYFriendTrendViewController ()
@property (weak, nonatomic) NSArray<GYRecommendFriendItem*> *recommendFriends;
@property (strong, nonatomic) NSMutableArray<GYTopicCellMode*> *topicCellsVM;
@property (weak, nonatomic) GYCoverView *coverView;
@property (assign, nonatomic) BOOL isFirstLoad;
@end

@implementation GYFriendTrendViewController
- (NSMutableArray<GYTopicCellMode *> *)topicCellsVM {
    if(_topicCellsVM == nil) {
        _topicCellsVM = [NSMutableArray array];
    }
    return _topicCellsVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self setupNavBar];
    
    GYCoverView *coverView = ({
        GYCoverView *coverView = [GYCoverView coverView];
        coverView.frame = self.view.bounds;
        [self.view addSubview:coverView];
        coverView;
    });
    _coverView = coverView;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYRecommendFriendCell class]) bundle:nil] forCellReuseIdentifier:recommendID];
    [self.tableView registerClass:[GYTopicCell class] forCellReuseIdentifier:selectedID];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadFriendRecommendData];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadFriendTopicData];
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
    
    _isFirstLoad = YES;
    [self.tableView.mj_header beginRefreshing];
//    [self loadFriendTopicData];
}
#pragma mark - 加载网络数据
- (void)loadFriendRecommendData { // 获取朋友推荐数据
    [[GYNetworkingManager shareManager] requestFriendRecommendData:^(NSArray *recommendFriends, NSError *error) {
        self.recommendFriends = recommendFriends;
        //       [self.tableView reloadData];
        //[UIView performWithoutAnimation:^{
        //    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        //}];
        
        if(self.isFirstLoad) {
            [self loadFriendTopicData];
            self.isFirstLoad = NO;
        } else {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            self.isFirstLoad = NO;
        }
    }];
}
- (void)loadFriendTopicData { // 获取关注朋友帖子
    [[GYNetworkingManager shareManager] requestFriendTopicData:^(NSArray *friendTopics, NSError *error) {
        for (GYTopicItem *item in friendTopics) {
            GYTopicCellMode *vm = [[GYTopicCellMode alloc] init];
            vm.topicItem = item;
            [self.topicCellsVM addObject:vm];
        }
        
        if(self.coverView) {
            [self.coverView removeFromSuperview];
        }
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
   }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
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

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 1;
    if(section == 1) {
        num =  _topicCellsVM.count;
    }
    return num;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        GYRecommendFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendID];
        cell.recommendFriends = _recommendFriends;
        return cell;
    } else {
        GYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedID];
        cell.vm = _topicCellsVM[indexPath.row];
       return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 100;
    if(indexPath.section == 0) {
        height = GYScreenH * 150.0 / 736;
    } else {
        GYTopicCellMode *vm = _topicCellsVM[indexPath.row];
        height = vm.cellHeight;
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
