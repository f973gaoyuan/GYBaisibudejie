//
//  GYLoginMenu.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/30.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYuserView.h"

@implementation GYuserView
+ (instancetype)loginView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
