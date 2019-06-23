//
//  GYCoverView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/22.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYCoverView.h"

@implementation GYCoverView

+ (instancetype)coverView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil][0];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
