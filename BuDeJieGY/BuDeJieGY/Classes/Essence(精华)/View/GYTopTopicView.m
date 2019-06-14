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
        [image drawAtPoint:CGPointZero];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.imageView.image = newImage;
    }];
    
    _nameLabel.text = topicItem.user.name;
    _contentLabel.text = topicItem.text;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
