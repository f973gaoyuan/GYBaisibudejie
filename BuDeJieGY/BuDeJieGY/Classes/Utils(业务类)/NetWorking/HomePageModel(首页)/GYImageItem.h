//
//  GYImageItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/12.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYImageItem : NSObject
//@property (strong, nonatomic) NSArray* medium;
@property (assign, nonatomic) NSInteger height;
//@property (strong, nonatomic) NSArray* download_url;
@property (assign, nonatomic) NSInteger width;
//@property (strong, nonatomic) NSArray* small;
//@property (strong, nonatomic) NSArray* thumbnail_small;
@property (strong, nonatomic) NSArray* big;
//@property (strong, nonatomic) UIImage *smallImage;

@end

NS_ASSUME_NONNULL_END
