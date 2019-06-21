//
//  GYSettingViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/3.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYSettingViewController.h"
#import "../Model/GYSettingItem.h"
#import "../View/GYSettingCell.h"

#import "../../Utils(业务类)/File/GYFileManager.h"


static NSString * const settingCellID = @"settingCell";

@interface GYSettingViewController ()
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSString *cachePath;
@property (strong, nonatomic) NSString *cacheSize;
@end

@implementation GYSettingViewController
- (NSMutableArray *)items {
    if(_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSString *)cachePath {
    if(_cachePath == nil) {
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *defaultPath = [cachePath stringByAppendingPathComponent:@"com.hackemist.SDImageCache/default"];
        _cachePath = defaultPath;
    }
    return _cachePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"设置";
    
    [GYSettingItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"isSwitch" : @"switch",
                 @"isArrow" : @"arrow",
                 @"isSubtitle" : @"subtitle",
                 @"isCleanCache" : @"cleanCache"
                 };
    }];
    
    [self getCacheSize];

    NSString *path = [[NSBundle mainBundle] pathForResource:@"setting.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    
    NSInteger count = array.count;
    for(NSInteger i = 0; i < count; i++) {
        NSArray *ar1 = array[i];
        NSArray *ar2 = [GYSettingItem mj_objectArrayWithKeyValuesArray:ar1];
        [self.items addObject:ar2];
    }
    
    
    UIButton *btn  = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //***************
        UIColor *color1 = [UIColor colorWithWhite:1 alpha:1];
        UIColor *color2 = [UIColor colorWithWhite:200/255.0 alpha:1];
        UIImage *image1 = [UIImage imageWithColor:color1];
        UIImage *image2 = [UIImage imageWithColor:color2];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setBackgroundImage:image2 forState:UIControlStateHighlighted];
        //***************
        btn.height = 44;
        
        [btn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    self.tableView.tableFooterView = btn;
    self.tableView.contentInset = UIEdgeInsetsMake(-26, 0, 0, 0);
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 8;
    
    //[self.tableView registerClass:[GYSettingCell class] forCellReuseIdentifier:settingCellID];
    
//    [self getFileSize];
//    NSUInteger size = [SDImageCache sharedImageCache].totalDiskSize;
//    GYLog(@"size -- %ld", size);
}

-(void)loginOut {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要退出吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 计算缓存
- (void)getCacheSize {
    [GYFileManager getDirectorySizeStr:self.cachePath completion:^(NSString * _Nonnull str) {
        self.cacheSize = str;
        [self.tableView reloadData];
    }];
}
#pragma mark - 清除缓存
- (void)cleanCache {
    [GYFileManager removeDirectory:self.cachePath];
    self.cacheSize = nil;
    [self getCacheSize];

    [SVProgressHUD showSuccessWithStatus:@"清除数据成功!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _items[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellID forIndexPath:indexPath];
    NSArray *array = _items[indexPath.section];
    GYSettingItem *item = array[indexPath.row];
    if(item.isCleanCache) {
        if(_cacheSize == nil) {
            item.cacheSize = @"正在计算...";
        } else {
            item.cacheSize = _cacheSize;
        }
        //item.cacheSize = [self getCacheSize];
    }
    cell.item = item;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = _items[indexPath.section];
    GYSettingItem *item = array[indexPath.row];
    if(item.isCleanCache && _cacheSize) {
        [self cleanCache];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end
