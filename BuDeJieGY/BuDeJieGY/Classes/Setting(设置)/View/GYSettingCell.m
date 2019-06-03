//
//  GYTSettingCell.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/3.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYSettingCell.h"
#import "../Model/GYSettingItem.h"

@interface GYSettingCell ()
@property (strong, nonatomic) UISwitch *mySwitch;
@end

@implementation GYSettingCell

- (UISwitch *)mySwitch {
    if (_mySwitch == nil) {
        _mySwitch = [[UISwitch alloc] init];
        _mySwitch.onTintColor = [UIColor redColor];
        self.mySwitch.x = GYScreenW - self.mySwitch.width - 20;
        CGPoint center = self.mySwitch.center;
        center.y = self.contentView.center.y;
        self.mySwitch.center = center;
    }
    return _mySwitch;
}

- (void)setItem:(GYSettingItem *)item {
    _item = item;
    self.textLabel.text = item.name;
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.detailTextLabel.text = @"";
    [self.mySwitch removeFromSuperview];
    //------------------------
    if(item.isArrow) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(item.isSwitch) {
        [self.contentView addSubview:self.mySwitch];
    }
    //------------------------
    if(item.isCleanCache) {
        self.detailTextLabel.text = [self getCacheSize];
    }
    //------------------------
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.detailTextLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.textColor = [UIColor grayColor];
    self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 计算缓存大小
- (NSString*)getCacheSize {
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
    
    //GYLog(@"file size: %ld", size);
    NSString *str = nil;
    if(size >= 1000000) {
        str = [NSString stringWithFormat:@"%.1fMB", size / 1000000.0];
    } if(size >= 1000) {
        str = [NSString stringWithFormat:@"%.1fMB", size / 1000.0];
    } else {
        str = [NSString stringWithFormat:@"%ldB", size];
    }
    
    return str;
}


@end
