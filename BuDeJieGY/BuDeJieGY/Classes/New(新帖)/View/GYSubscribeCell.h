//
//  GYTableViewCell.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/22.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYSubscribeItem;

@interface GYSubscribeCell : UITableViewCell
@property (strong, nonatomic) GYSubscribeItem *item;
+ (instancetype)subscribeCell;
@end

NS_ASSUME_NONNULL_END
