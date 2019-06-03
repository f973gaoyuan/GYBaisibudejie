//
//  GYBlockCell.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/29.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYSquareItem;
@interface GYBlockCell : UICollectionViewCell
@property (weak, nonatomic) GYSquareItem *item;
@end

NS_ASSUME_NONNULL_END
