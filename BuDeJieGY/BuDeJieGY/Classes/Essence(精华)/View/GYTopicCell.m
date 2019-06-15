//
//  GYTopicCell.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/9.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYTopicCell.h"
#import "GYTopTopicView.h"
#import "GYPictureTopicView.h"
#import "GYVideoTopicView.h"
#import "GYCommentTopicView.h"
#import "GYBottomTopicView.h"
#import "../Model/GYTopicItem.h"
#import "../VM/GYTopicCellMode.h"




@interface GYTopicCell ()
@property (weak, nonatomic) GYTopTopicView *topTopicView;
@property (weak, nonatomic) GYPictureTopicView *pictureTopicView;
@property (weak, nonatomic) GYVideoTopicView *videoTopicView;
@property (weak, nonatomic) GYCommentTopicView *commentTopicView;
@property (weak, nonatomic) GYBottomTopicView *bottomTopicView;
@end

@implementation GYTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.contentView.backgroundColor = GYColor(0, 0, 0);
        //设置顶部View内容，设置topView，设置Cell
        // 顶部
        GYTopTopicView *topTopicView = [GYTopTopicView viewForXib];
        [self.contentView addSubview:topTopicView];
        _topTopicView = topTopicView;
        // 中间
        // 图片
        GYPictureTopicView *pictureTopicView = [GYPictureTopicView viewForXib];
        [self.contentView addSubview:pictureTopicView];
        _pictureTopicView = pictureTopicView;
        //视频
        GYVideoTopicView *videoTopicView = [GYVideoTopicView viewForXib];
        [self.contentView addSubview:videoTopicView];
        _videoTopicView = videoTopicView;
        // 最热评论
        GYCommentTopicView *commentTopicView = [GYCommentTopicView viewForXib];
        [self.contentView addSubview:commentTopicView];
        _commentTopicView = commentTopicView;
        // 底部
        GYBottomTopicView *bottomTopicView = [GYBottomTopicView viewForXib];
        [self.contentView addSubview:bottomTopicView];
        _bottomTopicView = bottomTopicView;
        //GYLog(@"%s", __func__);
    }
    return self;
}

- (void)setVm:(GYTopicCellMode *)vm {
    _vm = vm;
    _topTopicView.topicItem = vm.topicItem;
    _topTopicView.frame = vm.topTopViewFrame;
    
    _pictureTopicView.hidden = YES;
    if([vm.topicItem.type isEqualToString:@"image"] || [vm.topicItem.type isEqualToString:@"gif"]) {
        _pictureTopicView.topicItem = vm.topicItem;
        _pictureTopicView.frame = vm.pictureTopicViewFrame;
        _pictureTopicView.hidden = NO;
    }
    
    _videoTopicView .hidden = YES;
    if([vm.topicItem.type isEqualToString:@"video"]) {
        _videoTopicView.topicItem = vm.topicItem;
        _videoTopicView.frame = vm.videoTopicViewFrame;
        _videoTopicView.hidden = NO;
    }
    
    _commentTopicView .hidden = YES;
    if(vm.topicItem.top_comments.count > 0) {
        _commentTopicView.topicItem = vm.topicItem;
        _commentTopicView.frame = vm.commentTopicViewFrame;
        _commentTopicView .hidden = NO;
    }
    
    _bottomTopicView.topicItem = vm.topicItem;
    _bottomTopicView.frame = vm.bottomTopicViewFrame;;
}

//- (void)setTopicItem:(GYTopicItem *)topicItem {
//    _topicItem = topicItem;
//    _topTopicView.topicItem = topicItem;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    //_topTopicView.frame = self.contentView.bounds;
    //GYLog(@"%s", __func__);
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
