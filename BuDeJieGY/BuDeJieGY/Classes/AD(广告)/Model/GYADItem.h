//
//  GYADItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYADItem : NSObject
/*
 img
 corporation_name
 rl
 pic_width:640,
 pic_height:1136,
 */
@property (strong, nonatomic) NSString* corporation_name;       // 公司名称
@property (strong, nonatomic) NSString* img;
@property (strong, nonatomic) NSString* rl;
@property (assign, nonatomic) NSInteger pic_width;
@property (assign, nonatomic) NSInteger pic_height;

@end

NS_ASSUME_NONNULL_END
