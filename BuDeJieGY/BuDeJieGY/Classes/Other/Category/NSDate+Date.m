//
//  NSDate+Date.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/17.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "NSDate+Date.h"

@implementation NSDate (Date)
- (BOOL)isThisYear {
    NSDate *curDate = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *timeCmp = [calendar components:NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                            fromDate:self];
    NSDateComponents *curCmp = [calendar components:NSCalendarUnitYear | NSCalendarUnitDay  | NSCalendarUnitHour | NSCalendarUnitMinute
                                           fromDate:curDate];
    
     if(timeCmp.year == curCmp.year) return YES;
    else return NO;
}

- (BOOL)isToday {
     return [[NSCalendar currentCalendar] isDateInToday:self];;
}

- (BOOL)isYestoday {
    return [[NSCalendar currentCalendar] isDateInYesterday:self];;
}

- (NSDateComponents*)deltaWithNow {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute
                       fromDate:self toDate:[NSDate date]
                        options:NSCalendarWrapComponents];
}
@end
