//
//  GYTopicVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/5.
//  Copyright © 2019 gaoyuan. All rights reserved.
//
#import "GYTopicVC.h"
#import "../../../Utils(业务类)/NetWorking/GYNetworkingManager.h"

#import "../../View/GYTopicCell.h"
#import "../../View/GYCoverView.h"

#import "../../VM/GYTopicCellMode.h"
/*
 不等高cell
 1. 自定义cell
 2. 划分层次结构(1. TOPView / 2. 中间(视频、图片、声音) / 3. 最热评论 / 4. 底部View)
 3. 不能使用xib描述cell， 很多东西不确定。
 4. 通过代码添加所有子结构
 5. 在哪添加initWithStyle
 6. 一开始就把所有的子结构全部添加上去
 */

/**
 MVVM
 VM: 视图模型，处理界面业务逻辑，就算尺寸，点击事件
     以前每个cell对应一个模型，现在每个cell对应一个视图模型
     每个视图模型都会保存自己的模型
 好处：如果是自己搭建的MVVM，非常爽
 坏处：可读性差，维护成本高
 */
static NSString * const ID = @"topicCell";

@interface GYTopicVC ()

@property (strong, nonatomic) NSMutableArray<GYTopicCellMode*> *topicCellsVM;
@property (weak, nonatomic) GYCoverView *coverView;
@property (weak, nonatomic) GYNetworkingManager *manager;

@end

@implementation GYTopicVC

- (NSMutableArray<GYTopicCellMode *> *)topicCellsVM {
    if(_topicCellsVM == nil) {
        _topicCellsVM = [NSMutableArray array];
    }
    return _topicCellsVM;
}

- (GYNetworkingManager *)manager {
    if(_manager == nil) {
        _manager = [GYNetworkingManager shareManager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GYColor(240, 240, 240);
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    GYCoverView *coverView = ({
        GYCoverView *coverView = [GYCoverView coverView];
        coverView.frame = self.view.bounds;
        [self.view addSubview:coverView];
        coverView;
    });
    _coverView = coverView;

    [self.tableView registerClass:GYTopicCell.class forCellReuseIdentifier:ID];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadTopicDataWithIndex:self.view.tag refreshType:GYRefreshTypePulldown];
    }];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadTopicDataWithIndex:self.view.tag refreshType:GYRefreshTypePullup];
    }];
    self.tableView.mj_footer.automaticallyChangeAlpha = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    GYLog(@".....%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}
#pragma mark - 加载网络数据
- (void)loadTopicDataWithIndex:(GYEssenceNetDataType)essenceNetDataType refreshType:(GYRefreshType)refreshType {
    self.view.tag = essenceNetDataType;
    [self.manager requestEssenceSubDataWithType:essenceNetDataType refreshType:refreshType completion:^(NSArray *topics, NSError *error) {
        if(refreshType == GYRefreshTypePulldown) {
            int insetIndex = 0;
            for (GYTopicItem *item in topics) {
                GYTopicCellMode *vm = [[GYTopicCellMode alloc] init];
                vm.topicItem = item;
                [self.topicCellsVM insertObject:vm atIndex:insetIndex];
                insetIndex++;
            }
        } else {
            for (GYTopicItem *item in topics) {
                GYTopicCellMode *vm = [[GYTopicCellMode alloc] init];
                vm.topicItem = item;
                [self.topicCellsVM addObject:vm];
            }
        }
        
        if(self.coverView) {
            [self.coverView removeFromSuperview];
        }

        [self.tableView reloadData];
        //self.tableView.contentOffset = CGPointMake(0, offset);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
        });
    }];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _topicCellsVM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    cell.vm = _topicCellsVM[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYTopicCellMode *vm = _topicCellsVM[indexPath.row];
    return vm.cellHeight;
}

@end
