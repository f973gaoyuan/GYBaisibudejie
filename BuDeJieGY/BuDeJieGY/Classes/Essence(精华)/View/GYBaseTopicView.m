//
//  GYBaseTopicView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/11.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYBaseTopicView.h"

@implementation GYBaseTopicView
+ (instancetype)viewForXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil][0];
}

@end
