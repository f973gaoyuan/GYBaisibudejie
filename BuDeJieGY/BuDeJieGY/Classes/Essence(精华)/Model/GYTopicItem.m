//
//  GYTopicItem.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/10.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYTopicItem.h"

@implementation GYTopicItem
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"top_comments": NSStringFromClass(GYCommentItem.class)};
}
@end
