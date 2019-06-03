//
//  GYTableViewCell.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/22.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYSubscribeCell.h"
#import <UIImageView+WebCache.h>

#import "../Model/GYSubscribeItem.h"

@interface GYSubscribeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image_list;
@property (weak, nonatomic) IBOutlet UILabel *theme_name;
@property (weak, nonatomic) IBOutlet UILabel *info;
@end

@implementation GYSubscribeCell

+ (instancetype)subscribeCell {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}


- (void)setItem:(GYSubscribeItem *)item {
    _item = item;
    
    [_image_list sd_setImageWithURL:[NSURL URLWithString:item.image_list]
                   placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]
                          completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        ///////////////////////////////
        //////////设置图片圆角///////////
        ///////////////////////////////
        CGFloat width = image.size.width;
        CGFloat height = image.size.height;
        CGFloat r = image.size.width * 6.0 / 76.0;
        //1. 开启图形上下文
        //opaque(不透明度):  YES->不透明  NO->透明
        //[UIScreen mainScreen].scale;
        UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
        //2. 描述裁剪区域
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:r];
        //3. 设置裁剪区域
        [clipPath addClip];
        //4. 绘图
        [image drawAtPoint:CGPointZero];
        //5. 取出图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        self.image_list.image = newImage;
        //6. 关闭图形上下文
        UIGraphicsEndImageContext();
    }];
    _theme_name.text = item.theme_name;
    _info.text = item.info;
}
/*
 cell 分割线全屏
 1. UIView
 2. 利用系统属性，iOS7开始 分割线往右边挪动
 2.1. iOS8出列一个属性，导致分割线往右边挪动一点点
 3. setFrame：万能
 3.1. 取消系统分割线
 3.2. 设置tabelView的背景色为分割线颜色
 3.3. setFrame，在设置frame之前，把高度减小1
 */
- (void)setFrame:(CGRect)frame {
    //frame.size.height -= 1;
    [super setFrame:frame];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    // 设置图片圆角，这种方法对性能不好。所以改用cocos2d方法裁剪
    //_image_list.layer.cornerRadius = 6;
    /////////////////////////////////////////////////
    // 让分割线占满整个屏幕宽度
//    NSString *version = [UIDevice currentDevice].systemVersion;
//    GYLog(@"%@", version);
//    GYLog(@"%@",NSStringFromUIEdgeInsets(self.layoutMargins));
    /*
    移除tableViewCell中某一行的分割线 有2种方法
 
    1. 移除系统的分割线，自己定义每行的分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
    2. 指定某行分割线隐藏
    [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, MAXFLOAT)];
    让分割线的宽度和cell的宽度一致
    self.preservesSuperviewLayoutMargins = false;
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    */
    self.separatorInset = UIEdgeInsetsZero;
    /////////////////////////////////////////////////
    // 取消选中状态显示
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
