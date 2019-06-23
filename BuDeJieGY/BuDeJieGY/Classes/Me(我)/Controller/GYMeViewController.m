//
//  GYMeViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/12.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <SafariServices/SafariServices.h>
#import "GYMeViewController.h"
#import "GYWebViewController.h"
#import "../../Setting(设置)/Controller/GYSettingViewController.h"
#import <AFNetworking.h>
#import <MJExtension/MJExtension.h>


#import "../View/GYBlockCell.h"
#import "../View/GYUserView.h"

static CGFloat const COLLECTIONCELL_HEIGHT  =    164;
static NSInteger const cols = 5;
static CGFloat const margin = 1;
static NSString* const ID = @"collectionView";

#define itemWH (GYScreenW - (cols - 1) * margin) / cols

@interface GYMeViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) NSMutableArray<GYSquareItem*> *squares;
@property (weak, nonatomic) UICollectionView *collectionView;
@end

@implementation GYMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GYLog(@"%s", __func__);

    [self setupNavBar];
    [self setupFootView];
    
    [[GYNetworkingManager shareManager] requestMeSquareData:^(NSMutableArray *squares, NSError *error) {
        self.squares = squares;
        NSInteger count = self.squares.count;
        NSInteger rows = (count - 1) / cols + 1;
        self.collectionView.height = rows * itemWH;
        self.tableView.tableFooterView = self.self.collectionView;
        [self resloveData];
        [self.collectionView reloadData];
    }];

    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupNavBar {
    //self.navigationItem.title = @"我的";
    //self.title = @"我的";
    
    //右边
    //UIBarButtonItem *nightMode = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"mine-moon-icon"]
    //                                                       selectedImage:[UIImage imageNamed:@"mine-moon-icon-click"]
    //                                                              target:self
    //                                                              action:@selector(nightClick:)];
    //UIBarButtonItem *setting = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"mine-setting-icon"]
    //                                                    highlightedImage:[UIImage imageNamed:@"mine-setting-icon-click"]
    //                                                              target:self
    //                                                              action:@selector(settingClick)];
    
    //self.navigationItem.rightBarButtonItems = @[setting, nightMode];
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithWhite:1 alpha:1];
    [self.navigationController.navigationBar setBackgroundAlphaValue:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageOriginalWithName:@"mine_setting_24x24_"] style:UIBarButtonItemStylePlain target:self action:@selector(settingClick)];

    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    //self.tableView.sectionHeaderHeight = 8;
    self.tableView.sectionFooterHeight = 9;
    
    GYUserView *view = [GYUserView userView];
    self.tableView.tableHeaderView = view;
}
#pragma mark - 补齐CollectionViewCell
- (void)resloveData { // 补齐CollectionViewCell
    NSInteger count = self.squares.count;
    NSInteger extra = count % cols;
    
    if(extra) {
        extra = cols - extra;
        for(int i = 0; i < extra; i++) {
            GYSquareItem *item = [[GYSquareItem alloc] init];
            [_squares addObject:item];
        }
    }
}
- (void)setupFootView {
    CGFloat height = COLLECTIONCELL_HEIGHT;
    
    // 以下抽取方法比较好 => 低耦合，高内聚 => 函数式编程 和 链式编程
    UICollectionViewFlowLayout *flowLayout = ({
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //CGFloat margin = 1;
        //CGFloat itemWH = itemWH;
        //CGFloat itemH = (height - margin) / 2;
        
        flowLayout.minimumLineSpacing = margin;
        flowLayout.minimumInteritemSpacing = margin;
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        flowLayout;
    });
    UICollectionView *collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, height) collectionViewLayout:flowLayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor colorWithWhite:240/255.0 alpha:1];
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYBlockCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
        collectionView;
    });
    _collectionView = collectionView;
    self.tableView.tableFooterView = collectionView;
}

- (void)settingClick {
    //GYSettingViewController *settingVC = [[GYSettingViewController alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GYSettingViewController" bundle:nil];
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GYMeViewController" bundle:nil];
    GYSettingViewController *settingVC = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _squares.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYBlockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.item = _squares[indexPath.row];
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GYSquareItem *item = _squares[indexPath.row];
//    if(SystemVersion >= 9.0) {
//        SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:item.url]];
//        [self presentViewController:vc animated:YES completion:nil];
//    } else if(SystemVersion >= 8.0) {
        GYWebViewController *vc = [[GYWebViewController alloc] init];
        vc.title = item.name;
        vc.url = [NSURL URLWithString:item.url];
        [self.navigationController pushViewController:vc animated:YES];
//    }
}

// 如果是系统默认导航控制器 以下代码无效
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
