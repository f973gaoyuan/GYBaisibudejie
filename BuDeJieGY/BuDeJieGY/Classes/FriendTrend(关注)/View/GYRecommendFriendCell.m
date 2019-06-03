//
//  GYRecommendFriendCell.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/24.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYRecommendFriendCell.h"
#import "GYUserBtn.h"
#import "../Model/GYRecommendFriendItem.h"

const NSUInteger USER_BTN_CNT   = 5;

@interface GYRecommendFriendCell ()
//@property (weak, nonatomic) IBOutlet GYUserBtn *userBtn;
@property (strong, nonatomic) NSMutableArray<GYUserBtn*> *userBtns;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelGY;
@end

@implementation GYRecommendFriendCell

- (NSMutableArray<GYUserBtn *> *)userBtns {
    if(_userBtns == nil) {
        _userBtns = [NSMutableArray array];
    }
    return _userBtns;
}

- (void)setRecommendFriends:(NSArray<GYRecommendFriendItem *> *)recommendFriends {
    _recommendFriends = recommendFriends;
    NSInteger count = recommendFriends.count;
    for (int i = 0; i < count; i++) {
        GYUserBtn *btn = _userBtns[i];
        btn.item = recommendFriends[i];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, MAXFLOAT);
    
    int count = 5;
    for (int i = 0; i < count; i++) {
        GYUserBtn *btn = [GYUserBtn buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setAdjustsImageWhenHighlighted:NO];
        [btn setTitle:@"用户" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"defaultUserIcon"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:btn];
        [self.userBtns addObject:btn];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count = _userBtns.count;
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.titleLabelGY.frame) + 3;
    CGFloat width = self.contentView.width / count;
    CGFloat height = self.contentView.height - y;
    
    for (int i = 0; i < count; i++) {
        GYUserBtn *btn = _userBtns[i];
        btn.frame = CGRectMake(x, y, width, height);
        x += width;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
