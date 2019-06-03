//
//  GYUserBtn.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/24.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYImageBtn;
@class GYRecommendFriendItem;
@interface GYUserBtn : GYImageBtn
@property (weak, nonatomic) GYRecommendFriendItem *item;
@end

NS_ASSUME_NONNULL_END
