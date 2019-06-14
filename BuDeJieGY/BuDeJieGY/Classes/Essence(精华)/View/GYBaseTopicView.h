//
//  GYBaseTopicView.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/11.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYTopicItem;
@interface GYBaseTopicView : UIView
{
//@public
    GYTopicItem *_topicItem;
}
@property (strong, nonatomic) GYTopicItem *topicItem;
+ (instancetype)viewForXib;
@end

NS_ASSUME_NONNULL_END
