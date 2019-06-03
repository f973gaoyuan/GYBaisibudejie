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
@end
