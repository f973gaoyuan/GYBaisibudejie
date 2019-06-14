//
//  GYCommentItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/14.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GYUserItem;
@interface GYCommentItem : NSObject
@property (strong, nonatomic) NSString*     content;
@property (assign, nonatomic) NSInteger     ID;//id;
@property (assign, nonatomic) NSInteger     hate_count;
@property (strong, nonatomic) NSString*     passtime;
@property (assign, nonatomic) NSInteger     voicetime;
@property (strong, nonatomic) NSString*     cmt_type;
@property (assign, nonatomic) NSInteger     like_count;
@property (strong, nonatomic) GYUserItem*   user;//u;
@property (strong, nonatomic) NSString*     voiceuri;
@property (assign, nonatomic) NSInteger     preuid;
@property (assign, nonatomic) NSInteger     status;
@property (assign, nonatomic) NSInteger     precid;
@end

NS_ASSUME_NONNULL_END
