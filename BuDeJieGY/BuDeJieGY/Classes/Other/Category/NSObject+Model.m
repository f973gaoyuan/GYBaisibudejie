//
//  NSObject+Model.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/message.h>

@implementation NSObject (Model)
+ (instancetype)modelWithDictionary:(NSDictionary*)dict {
    id objc = [[self alloc] init];
    
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        GYLog(@"%@", type);
        type = [type stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        type = [type stringByReplacingOccurrencesOfString:@"@" withString:@""];
    }
    
    return objc;
}
@end
