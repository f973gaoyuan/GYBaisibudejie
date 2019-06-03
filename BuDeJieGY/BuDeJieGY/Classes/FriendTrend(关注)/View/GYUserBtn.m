//
//  GYUserBtn.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/24.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYUserBtn.h"
#import <UIButton+WebCache.h>
#import "../Model/GYRecommendFriendItem.h"

@implementation GYUserBtn

- (void)setItem:(GYRecommendFriendItem *)item {
    _item = item;
    [self sd_setImageWithURL:[NSURL URLWithString:item.header]
                    forState:UIControlStateNormal
                   completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                       CGSize size = image.size;
                       UIGraphicsBeginImageContextWithOptions(size, NO, 0);
                       
                       UIBezierPath *fillPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
                       [[UIColor lightGrayColor] set];
                       [fillPath fill];
                       
                       int margin = 1;
                       UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(margin, margin, size.width-2*margin, size.height-2*margin)];
                       [clipPath addClip];
                       [image drawInRect:CGRectMake(margin, margin, size.width-2*margin, size.height-2*margin)];
                       
                       UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                       [self setImage:newImage forState:UIControlStateNormal];
                       UIGraphicsEndImageContext();
                   }];
    
    [self setTitle:item.screen_name forState:UIControlStateNormal];
}
/*
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 8;
    CGFloat space = 0;//5;
    
    /////////////////////////////////////

    CGRect bounds = self.bounds;
    
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    

    CGFloat labelH = 20;
    CGRect labelF = self.titleLabel.frame;
    labelF.origin.x = bounds.origin.x + margin;
    labelF.origin.y = height - labelH - margin;
    labelF.size.width = width - 2 * margin;
    labelF.size.height = labelH;
    
    CGFloat x = margin;
    CGFloat y = margin;
    CGFloat wf = width - 2*margin;
    CGFloat hf = height - 2*margin - labelH - space;
    
    if(wf < hf) {
        y += (hf - wf) / 2.0;
        hf = wf;
    } if(wf > hf) {
        x += (wf - hf) / 2.0;
        wf = hf;
    }
    
    CGRect imageF = CGRectMake(x, y, wf, hf);
    
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:(labelH - 8)];
    
    self.titleLabel.frame = labelF;
    self.imageView.frame = imageF;
    
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
