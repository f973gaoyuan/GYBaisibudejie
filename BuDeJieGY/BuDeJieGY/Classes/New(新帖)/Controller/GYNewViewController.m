//
//  GYNewViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/12.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYNewViewController.h"
#import "GYSubTagController.h"
//#import <SVProgressHUD.h>

#import "../Model/GYPromotionItem.h"
#import "../Model/GYSubscribeItem.h"
#import "../Model/GYHotSearchItem.h"

#import "../View/GYPromotionCell.h"
#import "../View/GYSubscribeCell.h"

#import "../../Other/Category/NSDictionary+Property.h"


static NSString* const subscribeID = @"subscribeCell";
static NSString* const promotionID = @"promotionCell";


@interface GYNewViewController ()
@property (strong, nonatomic) NSArray<GYPromotionItem*> *promotions;
@property (strong, nonatomic) NSArray<GYSubscribeItem*> *subscribes;
@property (strong, nonatomic) NSArray<GYHotSearchItem*> *hotSearches;
@property (weak, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation GYNewViewController

- (AFHTTPSessionManager *)manager {
    if(_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupNavBar];
    
    //[SVProgressHUD showWithStatus:@"正在加载数据..."];
    // 推广数据
    [self loadPromotionData];
    // 订阅数据
    [self loadSubscribeData];
    // 热门搜索
    [self loadHotSearchData];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSubscribeCell class]) bundle:nil] forCellReuseIdentifier:subscribeID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYPromotionCell class]) bundle:nil] forCellReuseIdentifier:promotionID];
    
    //self.tableView.backgroundColor = [UIColor grayColor];
    self.tableView.rowHeight = 100;
    self.tableView.estimatedRowHeight = 100;
}

- (void)setupNavBar {
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];

    //左
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"MainTagSubIcon"]
                           highlightedImage:[UIImage imageNamed:@"MainTagSubIconClick"]
                                     target:self
                                     action:@selector(subClick)];
    
 }

- (void)subClick {
    GYSubTagController *vc = [[GYSubTagController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 隐藏指示器
    //[SVProgressHUD dismiss];
    // 取消请求
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}
#pragma mark - 获取推广数据
- (void)loadPromotionData {
    NSString *urlStr = @"http://s.budejie.com/op2/promotion/bsbdjhd-iphone-5.0.9-appstore/0-100.json";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSArray *array = responseObject[@"result"][@"faxian"][@"1"];
        self.promotions = [GYPromotionItem mj_objectArrayWithKeyValuesArray:array];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark - 获取订阅数据
- (void)loadSubscribeData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *urlStr = @"http://d.api.budejie.com/forum/subscribe/bsbdjhd-iphone-5.0.9.json";
        [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
            self.subscribes = [GYSubscribeItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            [self.tableView reloadData];
            //[SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //[SVProgressHUD dismiss];
        }];
    });
}
#pragma mark - 获取热门搜索数据
- (void)loadHotSearchData {
    NSString *urlStr = @"http://d.api.budejie.com/topic/hotsearch/bsbdjhd-iphone-5.0.9/0-20.json";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        self.hotSearches = [GYHotSearchItem mj_objectArrayWithKeyValuesArray:responseObject[@"hot_search"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subscribes.count + 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        GYPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:promotionID forIndexPath:indexPath];
        cell.items = _promotions;
        return cell;
    } else {
        GYSubscribeCell *cell = [tableView dequeueReusableCellWithIdentifier:subscribeID forIndexPath:indexPath];
        cell.item = _subscribes[indexPath.row-1];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 100;
    if(indexPath.row == 0) {
        height = GYScreenW * 280 / 750;//155;
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
