//
//  UIBarButtonItem+Item.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/13.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)
//+ ()barButtonItemWithImage
+ (UIBarButtonItem*)barButtonItemWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(nullable id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highlightedImage forState:UIControlStateHighlighted];

    //不要让按钮扩大点击范围
    //老版本 如iOS9 会出现 btn 按钮范围以外点击，按钮会i响应的问题。
    //解决办法 把btn加到一个view上再加到UIBarButtonItem
    //UIView *view = [[UIView alloc] initWithFrame:btn.bounds];
    //[view addSubview:btn];
    //return [[UIBarButtonItem alloc] initWithCustomView:view];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    return [[UIBarButtonItem alloc] initWithCustomView:btn];;
}

+ (UIBarButtonItem*)barButtonItemWithImage:(UIImage*)image selectedImage:(UIImage*)selectedImage target:(nullable id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateHighlighted];
    [btn setImage:selectedImage forState:UIControlStateSelected];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchDown];

    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
