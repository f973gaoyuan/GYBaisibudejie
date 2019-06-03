//
//  GYPromotionCell.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/22.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYPromotionItem;
@interface GYPromotionCell : UITableViewCell
//@property (strong, nonatomic) GYPromotionItem *item;
@property (weak, nonatomic) NSArray<GYPromotionItem*> *items;
+ (instancetype)promotionCell;
@end

NS_ASSUME_NONNULL_END
