//
//  GYTopicVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/5.
//  Copyright © 2019 gaoyuan. All rights reserved.
//
#import "GYTopicVC.h"

#import "../../View/GYTopicCell.h"
#import "../../Model/GYEssenceItem.h"

#import "../../Model/GYTopicItem.h"
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
@property (strong, nonatomic) NSArray<GYEssenceItem*> *essenceItems;
@property (strong, nonatomic) NSArray<GYTopicItem*> *topicItems;
@property (strong, nonatomic) NSMutableArray<GYTopicCellMode*> *topicCellsVM;
@end

@implementation GYTopicVC

- (NSMutableArray<GYTopicCellMode *> *)topicCellsVM {
    if(_topicCellsVM == nil) {
        _topicCellsVM = [NSMutableArray array];
    }
    return _topicCellsVM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    [GYTopicItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id",
                 @"user": @"u"
                 };
    }];
    
    [GYCommentItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"ID" : @"id",
                 @"user": @"u"
                 };
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self.tableView registerClass:NSClassFromString(@"GYTopicCell") forCellReuseIdentifier:ID];
    [self.tableView registerClass:GYTopicCell.class forCellReuseIdentifier:ID];
    
    [self loadEssenceData];
    //[self loadEssenceSubDataWithIndex:0];
}

- (void)loadEssenceData {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *usrlStr = @"http://s.budejie.com/public/list-appbar/bsbdjhd-iphone-5.1.0/";
    [manager GET:usrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        self.essenceItems = [GYEssenceItem mj_objectArrayWithKeyValuesArray:responseObject[@"menus"][0][@"submenus"]];
        //[self loadEssenceSubDataWithIndex:index];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GYLog(@"%@", error);
    }];
}

- (void)loadEssenceSubDataWithIndex:(NSInteger)index {
    //__block i = index;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //i = 1;
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        if(index >= self.essenceItems.count) {
            @throw [NSException exceptionWithName:@"索引值超界" reason:@"获取精华模型数据的索引值超过最大值" userInfo:nil];
        }
        GYEssenceItem *essenceItem = self.essenceItems[index];
        NSString *usrlStr = [essenceItem.url stringByAppendingString:@"0-0/bsbdjhd-iphone-5.1.0/0-25.json"];
        [manager GET:usrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
            NSArray *array = [GYTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            self.topicItems = array;
            //BOOL bTest = NO;
            [self.topicCellsVM removeAllObjects];
            for (GYTopicItem *item in array) {
                GYTopicCellMode *vm = [[GYTopicCellMode alloc] init];
                vm.topicItem = item;
                [self.topicCellsVM addObject:vm];
//                if(vm.topicItem.top_comments && !bTest) {
//                    NSDictionary *dict = vm.topicItem.top_comments[0];
//                    [dict createProperyCode:dict];
//                    bTest = YES;
//                }
            }
            
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            GYLog(@"%@", error);
        }];
    });
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
