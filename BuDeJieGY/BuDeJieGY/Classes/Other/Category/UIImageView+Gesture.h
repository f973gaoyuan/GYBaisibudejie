//
//  UIImageView+Gesture.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Gesture)
- (void)addTapGestureRecognizerWithTarget:(nullable id)target action:(nullable SEL)action;
@end

NS_ASSUME_NONNULL_END
