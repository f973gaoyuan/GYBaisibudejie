//
//  GYCommentTopicView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/14.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYCommentTopicView.h"

@interface GYCommentTopicView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@end

@implementation GYCommentTopicView
- (void)setTopicItem:(GYTopicItem *)topicItem {
    _topicItem = topicItem;
    GYCommentItem *commentItem = topicItem.top_comments[0];
    
    _nameLabel.text = commentItem.user.name;
    _contentLabel.text = commentItem.content;
    NSString *str = [NSString stringWithFormat:@"%ld", commentItem.like_count];
    if(commentItem.like_count == 0) {
        str = @"赞";
    }
    [_zanBtn setTitle:str forState:UIControlStateNormal];
    
    NSURL *url = [NSURL URLWithString:commentItem.user.header[0]];
    [_imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       UIGraphicsEndImageContext();
        self.imageView.image = [UIImage circularImaeWithImage:image];
    }];
}

- (IBAction)zanClick:(UIButton*)btn {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = GYColor(240,240,240);
    /**
     以后只要界面没有问题，但是莫名q其妙报一些约束的错误，这时候应考虑取消自动拉伸的属性(iOS6)
     */
    //self.autoresizingMask = UIViewAutoresizingNone;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
