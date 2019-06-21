//
//  UIImageView+Gesture.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "UIImageView+Gesture.h"

@implementation UIImageView (Gesture)
- (void)addTapGestureRecognizerWithTarget:(nullable id)target action:(nullable SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:nil action:nil];
    [self addGestureRecognizer:tap];
}
@end
