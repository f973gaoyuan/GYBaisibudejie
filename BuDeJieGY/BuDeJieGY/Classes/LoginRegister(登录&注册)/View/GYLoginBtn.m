//
//  GYLoginBtn.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/27.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYLoginBtn.h"

@implementation GYLoginBtn

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.imageView.layer.cornerRadius = self.imageView.image.size.width * 0.5;
/*
    UIImage *image = [self currentImage];
    CGSize size = image.size;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //UIBezierPath *fillPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.width, size.height)];
    //[[UIColor grayColor] set];
    //[fillPath fill];

    int margin = 0;
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(margin, margin, size.width-2*margin, size.height-2*margin)];
    [clipPath addClip];
    
    [image drawInRect:CGRectMake(margin, margin, size.width-2*margin, size.height-2*margin)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setImage:newImage forState:UIControlStateNormal];
    UIGraphicsEndImageContext();*/
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
