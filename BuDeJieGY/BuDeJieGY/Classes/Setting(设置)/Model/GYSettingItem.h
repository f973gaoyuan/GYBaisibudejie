//
//  GYSettingItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/3.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYSettingItem : NSObject
@property (assign, nonatomic) BOOL isSwitch;
@property (assign, nonatomic) BOOL isArrow;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) BOOL isSubtitle;
@property (assign, nonatomic) BOOL isCleanCache;

@property (strong, nonatomic) NSString *cacheSize;
@end

NS_ASSUME_NONNULL_END
