//
//  UIBarButtonItem+Item.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/13.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Item)
+ (UIBarButtonItem*)barButtonItemWithImage:(UIImage*)image highlightedImage:(UIImage*)highlightedImage target:(nullable id)target action:(SEL)action;
+ (UIBarButtonItem*)barButtonItemWithImage:(UIImage*)image selectedImage:(UIImage*)selectedImage target:(nullable id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
