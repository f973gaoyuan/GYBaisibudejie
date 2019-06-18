//
//  NSDate+Date.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/17.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Date)
- (BOOL)isThisYear;
- (BOOL)isToday;
- (BOOL)isYestoday;
- (NSDateComponents*)deltaWithNow;
@end

NS_ASSUME_NONNULL_END
