//
//  GYVideoTopicView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/13.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYVideoTopicView.h"

@interface GYVideoTopicView ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) UIVisualEffectView *visualEffectView;
@end

@implementation GYVideoTopicView
- (UIVisualEffectView *)visualEffectView {
    if(_visualEffectView == nil) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        [_backImageView addSubview:visualEffectView];
        _visualEffectView = visualEffectView;
    }
    return _visualEffectView;
}
- (void)setTopicItem:(GYTopicItem *)topicItem {
    _topicItem = topicItem;
    NSString *str = nil;
    if(topicItem.video.playcount < 10000) {
        str = [NSString stringWithFormat:@"%ld播放", topicItem.video.playcount];
    } else {
        str = [NSString stringWithFormat:@"%.1f万播放", topicItem.video.playcount / 10000.0];
    }
    _countLabel.text = str;
    //--------------------
    //hour=sec/3600; //计算时 3600进制
    NSInteger min = (topicItem.video.duration % 3600) / 60; //计算分 60进制
    NSInteger sec = (topicItem.video.duration % 3600) % 60; //计算秒 余下的全为秒数
    str = [NSString stringWithFormat:@"%02ld:%02ld", min, sec];
    _durationLabel.text = str;
    //--------------------
    NSURL *url = [NSURL URLWithString:topicItem.video.thumbnail[0]];
    [_backImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //UIVisualEffectView *visualEffectView =
        
        self.videoImageView.image = image;
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if(_topicItem.video) {
        self.visualEffectView.frame = self.bounds;
        
        CGSize size = CGSizeMake(self.width, self.height);
        CGFloat videoX = 0;
        CGFloat videoY = 0;
        CGFloat videoW = size.width;
        CGFloat videoH = videoW * _topicItem.video.height / _topicItem.video.width;
        if(videoH > size.height) {
            videoH = size.height;
            videoW = videoH * _topicItem.video.width / _topicItem.video.height;
            videoX = (size.width - videoW) / 2;
        }
        _videoImageView.frame = CGRectMake(videoX, videoY, videoW, videoH);
    }

}

- (IBAction)playStartBtnClick:(UIButton*)btn {
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
