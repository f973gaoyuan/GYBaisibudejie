//
//  GYNetworkingManager.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/21.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AdvertisementModel(广告)/GYADItem.h"

#import "HomePageModel(首页)/GYEssenceItem.h"
#import "HomePageModel(首页)/GYTopicItem.h"
#import "HomePageModel(首页)/GYUserItem.h"
#import "HomePageModel(首页)/GYImageItem.h"
#import "HomePageModel(首页)/GYGIfItem.h"
#import "HomePageModel(首页)/GYVideoItem.h"
#import "HomePageModel(首页)/GYCommentItem.h"

#import "CommunityMode(社区)/GYPromotionItem.h"
#import "CommunityMode(社区)/GYSubscribeItem.h"
#import "CommunityMode(社区)/GYHotSearchItem.h"

#import "FriendTrendModel(关注)/GYRecommendFriendItem.h"

//NS_ASSUME_NONNULL_BEGIN

@interface GYNetworkingManager : NSObject
@property (strong, nonatomic) NSArray<GYEssenceItem*> *essenceItems;
/**
 创建一个单例对象
 */
+ (instancetype)shareManager;
/**
 取消所有请求
 */
- (void)cancelAllRequest;
//====================================
// 广告
/**
 请求启动广告数据
 */
- (void)requestStartupADData:(void(^)(GYADItem *item, NSError * error))completionHandle;
//====================================
// 首页
/**
 请求精华数据列表
 */
- (void)requestEssenceData:(void(^)(NSArray * essences, NSError * error))completionHandle;
/**
 请求精华数据 参数index: 0-推荐 1-视屏 2-图片 3-笑话 4-娱乐
 */
- (void)requestEssenceSubDataWithIndex:(NSInteger)index completion:(void(^)(NSArray *topics, NSError * error))completionHandle;
//====================================
// 社区
/**
 请求社区推广数据
 */
- (void)requestPromotionData:(void(^)(NSArray *promotions, NSError * error))completionHandle;
/**
 请求社区订阅数据
 */
- (void)requestSubscribeData:(void(^)(NSArray *subscribes, NSError * error))completionHandle;
/**
 请求社区热门搜索数据
 */
- (void)requestHotSearchData:(void(^)(NSArray *hotSearches, NSError * error))completionHandle;
//====================================
// 关注
/**
 请求推荐朋友
 */
- (void)requestFriendRecommendData:(void(^)(NSArray *recommendFriends, NSError * error))completionHandle;
/**
 请求关注朋友帖子
 */
- (void)requestFriendTopicData:(void(^)(NSArray *friendTopics, NSError * error))completionHandle;
@end

//NS_ASSUME_NONNULL_END
