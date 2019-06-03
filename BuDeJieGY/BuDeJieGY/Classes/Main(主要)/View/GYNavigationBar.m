//
//  GYNavigationBar.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/15.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYNavigationBar.h"
#import "../../Other/Category/UIView+frame.h"

@interface GYNavigationBar ()

@end
@implementation GYNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
#if 0
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        for (UIView *view in self.subviews) {
            if([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarContentView"]) {
                for (UIView *subView in view.subviews) {
                    if([NSStringFromClass([subView class]) isEqualToString:@"_UIButtonBarStackView"]) {
                        for (UIView *thirdV in subView.subviews) {
                            if([NSStringFromClass([thirdV class]) isEqualToString:@"_UITAMICAdaptorView"]) {
                                //GYLog(@"%@", thirdV.subviews);
                                for(UIView *desView in thirdV.subviews) {
                                    
                                    if([NSStringFromClass([desView class]) isEqualToString:@"GYBackBtn"]) {
 
                                        GYBackBtn *btn = (GYBackBtn *)desView;
                                        if(!btn.isSetOffSet) {
                                            btn.x -= 10;
                                            btn.btnX = btn.x;
                                        //    GYLog(@"%@", subView);
                                        //    GYLog(@"%@", thirdV);
                                        //    GYLog(@"%@", btn);
                                            btn.isSetOffSet = YES;
                                        } else {
                                            btn.x = btn.btnX;
                                        }
                                        //subView.x = 10;// 默认是20
                                        //subView.width = [UIScreen mainScreen].bounds.size.width - 20;
                                        //btn.x = 0;
                                        //GYLog(@"%@", desView);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    } else {
//        for (UIView *view in self.subviews) {
//            if([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarContentView"]) {
//            }
//        }
    }
#endif
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
