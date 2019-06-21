//
//  GYTopTopicView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/10.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYTopTopicView.h"

/* 时间显示逻辑
 今年
 今天
 >1 小时
 2 小时前
 
 >=1 分钟
 1分钟前
 
 < 1分钟
 刚刚
 
 昨天
 昨天 14:30
 
 昨天之前
 10-23 14:37:20
 
 
 非今年
 2015-10-26 14:37:20
 */


@interface GYTopTopicView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
@implementation GYTopTopicView
- (void)setTopicItem:(GYTopicItem *)topicItem {
    _topicItem = topicItem;
    
    NSURL *url = [NSURL URLWithString:topicItem.user.header[0]];
    [_imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.imageView.image = [UIImage circularImaeWithImage:image];
    }];
    
    _nameLabel.text = topicItem.user.name;
    //_contentLabel.text = topicItem.text;
//    if([topicItem.ID isEqualToString:@"29604184"]) {
//        int i = 0;
//    }

    if(topicItem.status == GYTopicStatusEssence) {
        UIImage *isBestImage = [UIImage imageNamed:@"icon_isbest_27x14_"];

        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = isBestImage;
        attach.bounds = CGRectMake(0, -2, isBestImage.size.width, isBestImage.size.height);

        // 初始化富文本字符串 并携带 NSTextAttachment
        //NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment:attach];
        NSMutableAttributedString *attrStr = (NSMutableAttributedString *)[NSMutableAttributedString attributedStringWithAttachment:attach];
        // 初始化一个空的可变字符串
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:@" "];
        NSAttributedString *attrContent = [[NSAttributedString alloc] initWithString:topicItem.text];

        [attrText appendAttributedString:attrContent];
        [attrStr appendAttributedString:attrText];

        [_contentLabel setAttributedText:attrStr];
    } else {// if(topicItem.status == GYTopicStatusNormal) {
        _contentLabel.text = topicItem.text;
    }
    
    //[self passTime];
    //GYLog(@"%@", [self distanceTime:topicItem.passtime]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
}
#warning gaoyuan 未使用“仿微信时间显示”
- (NSString*)distanceTime:(NSString*)timeStr {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *timeDate = [fmt dateFromString:timeStr];
    
    NSString *str = timeStr;
    
    NSDateComponents *deltaCmp = [timeDate deltaWithNow];
    //GYLog(@"%@", deltaCmp);
    if([timeDate isThisYear]) { // 今年
        if([timeDate isToday]) { // 今天
            //
            if(deltaCmp.hour > 1) {
                str = [NSString stringWithFormat:@"%ld小时前", deltaCmp.hour];
            } else if (deltaCmp.minute > 1) {
                str = [NSString stringWithFormat:@"%ld分钟前", deltaCmp.minute];
            } else {
                str = @"刚刚";
            }
        } else if([timeDate isYestoday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            str = [fmt stringFromDate:timeDate];
        } else {
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            str = [fmt stringFromDate:timeDate];
        }
    }
    
    return str;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
