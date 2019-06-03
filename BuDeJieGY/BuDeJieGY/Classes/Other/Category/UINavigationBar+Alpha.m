//
//  UINavigationBar+Alpha.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/26.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "UINavigationBar+Alpha.h"

@implementation UINavigationBar (Alpha)
- (void)setBackgroundAlphaValue:(CGFloat)Alpha {
    UIColor *color1 = [UIColor colorWithWhite:1 alpha:Alpha];
    UIColor *color2 = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:Alpha];
    
    UIImage *image1 = [UIImage imageWithColor:color1];
    UIImage *image2 = [UIImage imageWithColor:color2];
    
    [self setBackgroundImage:image1 forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:image2];
}



@end
