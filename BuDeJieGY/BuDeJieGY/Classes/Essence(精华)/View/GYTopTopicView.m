//
//  GYTopTopicView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/10.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYTopTopicView.h"
#import "../Model/GYUserItem.h"
#import "../Model/GYTopicItem.h"

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
    _contentLabel.text = topicItem.text;
    
    
    
    if(topicItem.status == 4) {
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
    }// else if(topicItem.status == GYTopicStatusNormal) {
//        _contentLabel.text = topicItem.text;
//    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
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
