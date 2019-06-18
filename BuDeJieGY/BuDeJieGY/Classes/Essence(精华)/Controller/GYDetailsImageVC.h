//
//  GYDetailsImageVC.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYTopicItem;
@interface GYDetailsImageVC : UIViewController
@property (strong, nonatomic) GYTopicItem *topicItem;
- (instancetype)initWithTopicItem:(GYTopicItem*)item;
@end

NS_ASSUME_NONNULL_END
