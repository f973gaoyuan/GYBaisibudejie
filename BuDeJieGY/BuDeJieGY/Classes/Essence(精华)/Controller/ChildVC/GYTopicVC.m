//
//  GYTopicVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/5.
//  Copyright © 2019 gaoyuan. All rights reserved.
//
#import "GYTopicVC.h"
#import "../../../Utils(业务类)/NetWorking/GYNetworkingManager.h"

#import "../../View/GYFooterRefreshView.h"

#import "../../View/GYTopicCell.h"
#import "../../View/GYCoverView.h"
//#import "../../Model/GYEssenceItem.h"

//#import "../../Model/GYTopicItem.h"
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
//@property (strong, nonatomic) NSArray<GYEssenceItem*> *essenceItems;
@property (strong, nonatomic) NSMutableArray<GYTopicCellMode*> *topicCellsVM;
@property (weak, nonatomic) GYFooterRefreshView *footerRefreshView;
@property (weak, nonatomic) GYCoverView *coverView;
@property (weak, nonatomic) GYNetworkingManager *manager;
@property (assign, nonatomic) BOOL isLoadingData;
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
    [self setupBotomRefreshView];
    
    GYCoverView *coverView = [GYCoverView coverView];
    coverView.frame = self.view.bounds;
    [self.view addSubview:coverView];
    _coverView = coverView;
    _isLoadingData = YES;

    [self.topicCellsVM removeAllObjects];
    
    [self.tableView registerClass:GYTopicCell.class forCellReuseIdentifier:ID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    GYLog(@".....%@", NSStringFromUIEdgeInsets(self.tableView.contentInset));
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)setupBotomRefreshView {
    GYFooterRefreshView *refreshView = [GYFooterRefreshView bottomRefreshView];
    self.tableView.tableFooterView = refreshView;
    _footerRefreshView = refreshView;
}
#pragma mark - 加载网络数据
- (void)loadTopicDataWithIndex:(GYEssenceNetDataType)essenceNetDataType {
    self.view.tag = essenceNetDataType;
    _isLoadingData = YES;
    //__block CGFloat offset = self.tableView.contentOffset.y;
    [self.manager requestEssenceSubDataWithType:essenceNetDataType completion:^(NSArray *topics, NSError *error) {
        for (GYTopicItem *item in topics) {
            GYTopicCellMode *vm = [[GYTopicCellMode alloc] init];
            vm.topicItem = item;
            [self.topicCellsVM addObject:vm];
        }
        //CGFloat offset = self.tableView.contentOffset.y;
        [self.tableView reloadData];
        //self.tableView.contentOffset = CGPointMake(0, offset);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.footerRefreshView.refreshData = NO;
            self.isLoadingData = NO;
            if(self.coverView) {
                [self.coverView removeFromSuperview];
            }
        });
    }];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
    [[SDImageCache sharedImageCache] clearMemory];
    
    if(_isLoadingData)  return;
    GYLog(@"%@ - %@", NSStringFromCGSize(self.tableView.contentSize), NSStringFromCGPoint(self.tableView.contentOffset));
    if(!_footerRefreshView.isRefreshData) {
        UIEdgeInsets inset = self.tableView.contentInset;
        CGFloat maxY = self.tableView.contentSize.height - (GYScreenH - inset.bottom);
        if(self.tableView.contentOffset.y > maxY) {
            [self loadTopicDataWithIndex:self.view.tag];
            _footerRefreshView.refreshData = YES;
        }
    }
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
