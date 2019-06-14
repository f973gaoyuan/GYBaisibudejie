//
//  GYTopicItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/10.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYUserItem.h"
#import "GYGIfItem.h"
#import "GYImageItem.h"
#import "GYVideoItem.h"
#import "GYCommentItem.h"

NS_ASSUME_NONNULL_BEGIN
//@class GYUserItem;
//@class GYImageItem;
@interface GYTopicItem : NSObject
@property (assign, nonatomic) NSInteger     status;
@property (strong, nonatomic) NSString*     rating;
@property (strong, nonatomic) NSString*     cate;
@property (strong, nonatomic) NSArray*      top_comments;   //****** *****
@property (strong, nonatomic) NSArray*      tags;           //****** *****
@property (strong, nonatomic) NSString*     bookmark;
@property (strong, nonatomic) NSString*     text;
@property (assign, nonatomic) NSInteger     is_best;        //******
@property (strong, nonatomic) GYGIfItem*    gif;            //****** *****
@property (assign, nonatomic) NSInteger     video_signs;
@property (strong, nonatomic) NSString*     share_url;
@property (strong, nonatomic) NSString*     up;             //******
@property (assign, nonatomic) NSInteger     down;
@property (assign, nonatomic) NSInteger     forward;
@property (strong, nonatomic) GYUserItem*   user;           //****** OK
@property (strong, nonatomic) GYImageItem*  image;           //****** *****
@property (strong, nonatomic) NSString*     passtime;
@property (strong, nonatomic) GYVideoItem*  video;          //****** *****
@property (strong, nonatomic) NSString*     type;
@property (strong, nonatomic) NSString*     ID;             //******
@property (strong, nonatomic) NSString*     comment;        //******


//@property (strong, nonatomic) NSDictionary* top_comment;
@end

NS_ASSUME_NONNULL_END
