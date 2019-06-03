//
//  GYLoginView.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/26.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYLogRegView;
@protocol GYLogRegViewDelegate <NSObject>
- (void)logRegViewOpenPrivacyPolicy:(GYLogRegView*)logRegV;
@end

@interface GYLogRegView : UIView
+ (instancetype)loginView;
+ (instancetype)registerView;
@property (weak, nonatomic) id<GYLogRegViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
