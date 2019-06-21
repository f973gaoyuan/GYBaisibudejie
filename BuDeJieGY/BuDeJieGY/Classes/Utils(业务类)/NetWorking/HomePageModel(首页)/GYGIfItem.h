//
//  GYGIfItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/13.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYGIfItem : NSObject
@property (strong, nonatomic) NSArray* download_url;
@property (assign, nonatomic) NSInteger height;
@property (assign, nonatomic) NSInteger width;
@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) NSArray* gif_thumbnail;
@end

NS_ASSUME_NONNULL_END
