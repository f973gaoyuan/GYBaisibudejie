//
//  GYTool.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYTool : NSObject
+ (NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
