//
//  GYFriendRecommendItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/23.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYRecommendFriendItem : NSObject
@property (strong, nonatomic) NSString* header;
@property (assign, nonatomic) NSInteger uid;
@property (assign, nonatomic) NSInteger is_follow;
@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSString* introduction;
@property (assign, nonatomic) NSInteger fans_count;
@property (assign, nonatomic) NSInteger tiezi_count;
@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) BOOL is_vip;
@property (strong, nonatomic) NSString* screen_name;
@property (strong, nonatomic) NSString* social_name;
@end

NS_ASSUME_NONNULL_END
