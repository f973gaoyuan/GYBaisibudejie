//
//  UIImage+Image.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/26.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, [color CGColor]);
    CGContextFillRect(ref, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)circularImaeWithImage:(UIImage*)image {
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
    
    return newImage;
}
@end
