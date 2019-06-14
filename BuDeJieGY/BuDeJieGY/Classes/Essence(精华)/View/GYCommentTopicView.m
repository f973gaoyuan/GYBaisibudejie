//
//  GYCommentTopicView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/14.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYCommentTopicView.h"
#import "../Model/GYTopicItem.h"


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
    [_zanBtn setTitle:str forState:UIControlStateNormal];
    
    NSURL *url = [NSURL URLWithString:commentItem.user.header[0]];
    [_imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGSize size = image.size;
        CGPoint pt = CGPointZero;
        if(size.width > size.height) {
            pt.x = - (size.width - size.height) / 2;
            size.width = size.height;
        } else if(size.width < size.height) {
            pt.y = - (size.height - size.width) / 2;
            size.height = size.width;
        }
        UIGraphicsBeginImageContextWithOptions(size, 0, 0);
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
        [clipPath addClip];
        [image drawAtPoint:pt];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.imageView.image = newImage;
    }];
}

- (IBAction)zanClick:(UIButton*)btn {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = GYColor(240,240,240);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
