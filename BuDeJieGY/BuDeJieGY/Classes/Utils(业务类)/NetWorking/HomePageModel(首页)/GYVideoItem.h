//
//  GYVideoItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/13.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYVideoItem : NSObject
@property (assign, nonatomic) NSInteger height;
@property (strong, nonatomic) NSArray* thumbnail;
//@property (strong, nonatomic) NSArray* download;
@property (assign, nonatomic) NSInteger width;
//@property (assign, nonatomic) NSInteger playfcount;
@property (assign, nonatomic) NSInteger duration;
//@property (strong, nonatomic) NSArray* thumbnail_small;
@property (strong, nonatomic) NSArray* video;
@property (assign, nonatomic) NSInteger playcount;
@end

NS_ASSUME_NONNULL_END
