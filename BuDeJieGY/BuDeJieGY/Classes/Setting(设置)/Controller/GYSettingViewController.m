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

#import <MJExtension/MJExtension.h>
#import <SDImageCache.h>

static NSString * const settingCellID = @"settingCell";

@interface GYSettingViewController ()
@property (strong, nonatomic) NSMutableArray *items;
@end

@implementation GYSettingViewController
- (NSMutableArray *)items {
    if(_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
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
    
    [self getFileSize];
    NSUInteger size = [SDImageCache sharedImageCache].totalDiskSize;
    GYLog(@"size -- %ld", size);
}

-(void)loginOut {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您确定要退出吗？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// 计算SDWebImage的缓存大小
- (void)getFileSize {
    //NSFileManager
    // attributesOfItemAtPath:指定文件路径,就能获取文件属性
    // 把所有文件尺寸加起来
    
    // 获取cache文件夹路径
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    // 获取default文件路径
    NSString *defaultPath = [cachePath stringByAppendingPathComponent:@"com.hackemist.SDImageCache"];
    
    // 获取文件管理者
    NSFileManager *manager = [NSFileManager defaultManager];
    
    // 获取文件夹所有子路径数组：获取多级路径下文件路经
    NSArray *subPathes = [manager subpathsAtPath:defaultPath];
    
    NSInteger size = 0;
    for (NSString *subPath in subPathes) {
        NSString *filePath = [defaultPath stringByAppendingPathComponent:subPath];
        NSDictionary *dict = [manager attributesOfItemAtPath:filePath error:nil];
        // 判断是否是隐藏文件
        if([filePath containsString:@".DS"])    continue;
        // 判断是否是文件夹
        BOOL isDirectory;
        BOOL isExists = [manager fileExistsAtPath:filePath isDirectory:&isDirectory];
        if(!isExists || isDirectory)           continue;
        
        size += [dict fileSize];
    }

    GYLog(@"file size: %ld", size);
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
    cell.item = array[indexPath.row];
    return cell;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
