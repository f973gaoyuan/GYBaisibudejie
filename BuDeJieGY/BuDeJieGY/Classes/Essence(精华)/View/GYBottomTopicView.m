//
//  GYBottomTopicView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/15.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYBottomTopicView.h"
#import "../Model/GYTopicItem.h"

@interface GYBottomTopicView ()
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@end

@implementation GYBottomTopicView
- (IBAction)upBtnClick:(UIButton *)btn {
}
- (IBAction)downBtnClick:(UIButton *)btn {
}
- (IBAction)commentBtnClick:(UIButton *)btn {
}
- (IBAction)forwardBtnClick:(UIButton *)sender {
}

- (void)setTopicItem:(GYTopicItem *)topicItem {
    _topicItem = topicItem;
    [self refreshData];
}

- (void)refreshData {
    NSString *str = @"赞";
    if([_topicItem.up intValue] > 0) {
        str = _topicItem.up;
    }
    [_upBtn setTitle:str forState:UIControlStateNormal];
    
    str = @"踩";
    if([_topicItem.down intValue] > 0) {
        str = _topicItem.down;
    }
    [_downBtn setTitle:str forState:UIControlStateNormal];
    
    str = @"评论";
    if([_topicItem.comment intValue] > 0) {
        str = _topicItem.comment;
    }
    [_commentBtn setTitle:str forState:UIControlStateNormal];
    
    str = @"分享";
    if([_topicItem.forward intValue] > 0) {
        str = _topicItem.forward;
    }
    [_forwardBtn setTitle:str forState:UIControlStateNormal];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = GYColor(240, 240, 240);
    self.autoresizingMask = UIViewAutoresizingNone;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
