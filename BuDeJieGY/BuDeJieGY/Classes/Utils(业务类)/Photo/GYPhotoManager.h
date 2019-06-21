//
//  GYPhotoManager.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/20.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYPhotoManager : NSObject
+ (void)savePhoto:(UIImage*)image albumTitle:(NSString*)albumTitle completionHandle:(void(^)(NSError *error, NSString *localIndentifier))completionHandler;
@end

NS_ASSUME_NONNULL_END
