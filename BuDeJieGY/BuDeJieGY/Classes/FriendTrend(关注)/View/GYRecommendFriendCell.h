//
//  GYRecommendFriendCell.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/24.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYRecommendFriendItem;
@interface GYRecommendFriendCell : UITableViewCell
@property (weak, nonatomic) NSArray<GYRecommendFriendItem*> *recommendFriends;
@end

NS_ASSUME_NONNULL_END
