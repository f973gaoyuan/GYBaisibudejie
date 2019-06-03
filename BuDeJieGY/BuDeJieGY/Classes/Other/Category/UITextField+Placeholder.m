//
//  UITextField+Placeholder.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/28.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "UITextField+Placeholder.h"

@implementation UITextField (Placeholder)
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if(self.placeholder.length == 0) {
        self.placeholder = @" ";
    }
    UILabel *label = [self valueForKey:@"placeholderLabel"];
    label.textColor = placeholderColor;
}

- (UIColor*)placeholderColor {
    UILabel *label = [self valueForKey:@"placeholderLabel"];
    return label.textColor;
}
@end
