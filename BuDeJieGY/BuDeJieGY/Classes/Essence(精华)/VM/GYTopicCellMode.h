//
//  GYTopicCellMode.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/11.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GYTopicItem;
@interface GYTopicCellMode : NSObject
@property (weak, nonatomic) GYTopicItem *topicItem;

@property (assign, nonatomic) CGRect topTopViewFrame;
//@property (assign, nonatomic) CGFloat topViewLabelH;
//----------------
@property (assign, nonatomic) CGRect pictureTopicViewFrame;
//@property (assign, nonatomic) CGFloat pictureTopicH;
//@property (strong, nonatomic) UIImage *smallImage;
//----------------
@property (assign, nonatomic) CGRect videoTopicViewFrame;
//----------------
@property (assign, nonatomic) CGRect commentTopicViewFrame;
//----------------
@property (assign, nonatomic) CGRect bottomTopicViewFrame;



@property (assign, nonatomic) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
