//
//  GYUserItem.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/10.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYUserItem : NSObject
@property (strong, nonatomic) NSArray* header;
@property (assign, nonatomic) NSInteger relationship;
@property (strong, nonatomic) NSString* uid;
@property (assign, nonatomic) BOOL is_vip;
@property (assign, nonatomic) BOOL is_v;
@property (strong, nonatomic) NSString* room_url;
@property (strong, nonatomic) NSString* room_name;
@property (strong, nonatomic) NSString* room_role;
@property (strong, nonatomic) NSString* room_icon;
@property (strong, nonatomic) NSString* name;
@end

NS_ASSUME_NONNULL_END
