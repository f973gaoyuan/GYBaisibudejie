//
//  GYTopicCell.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/9.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYTopicCellMode;
@interface GYTopicCell : UITableViewCell
@property (weak, nonatomic) GYTopicCellMode *vm;

@end

NS_ASSUME_NONNULL_END
