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

#import "../View/GYPromotionCell.h"
#import "../View/GYSubscribeCell.h"

#import "../../Other/Category/NSDictionary+Property.h"


static NSString* const subscribeID = @"subscribeCell";
static NSString* const promotionID = @"promotionCell";


@interface GYNewViewController ()
@property (weak, nonatomic) NSArray<GYPromotionItem*> *promotions;
@property (weak, nonatomic) NSArray<GYSubscribeItem*> *subscribes;
@property (weak, nonatomic) NSArray<GYHotSearchItem*> *hotSearches;
@end

@implementation GYNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupNavBar];
    
    //[SVProgressHUD showWithStatus:@"正在加载数据..."];
    GYNetworkingManager *manager = [GYNetworkingManager shareManager];
    // 推广数据
    [manager requestPromotionData:^(NSArray *promotions, NSError *error) {
        self.promotions = promotions;
    }];
    // 订阅数据
    [manager requestSubscribeData:^(NSArray *subscribes, NSError *error) {
        self.subscribes = subscribes;
        [self.tableView reloadData];
    }];
    // 热门搜索
    [manager requestHotSearchData:^(NSArray *hotSearches, NSError *error) {
        self.hotSearches = hotSearches;
    }];
    
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
    //[_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
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
