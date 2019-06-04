//
//  GYFileManager.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/4.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 添加业务类注意点：
 1. 指定当前类是用来干嘛的，写在文件顶部或者类的顶部
 2. 每个方法必须要有文档注释
 3. 每个方法要做容错处理，提前排除其他使用者犯的错误
 */

NS_ASSUME_NONNULL_BEGIN

@interface GYFileManager : NSObject
/**
 指定一个文件夹的路径，通过block返回文件夹的尺寸
 参数dirPath：文件夹路径
 */
+ (void)getDirectorySize:(NSString*)dirPath completion:(void(^)(NSInteger size))completion;
/**
 指定一个文件夹的路径，通过block返回该文件夹尺寸字符串。
 参数dirPath：文件夹路径
 */
+ (void)getDirectorySizeStr:(NSString*)dirPath completion:(void(^)(NSString*))completion;
/**
 指定一个文件夹的路径，计算该文件夹的大小。
 参数dirPath：文件夹路径
 返回：文件夹的尺寸
 */
+ (NSInteger)directorySize:(NSString*)dirPath;
/**
 指定一个文件夹的路径，返回该文件夹尺寸字符串。
 参数dirPath：文件夹路径
 */
+ (NSString*)directorySizeStr:(NSString*)dirPath;
/**
 删除文件夹内所有文件。
 参数dirPath：文件夹路径
 */
+ (void)removeDirectory:(NSString*)dirPath;


@end

NS_ASSUME_NONNULL_END
