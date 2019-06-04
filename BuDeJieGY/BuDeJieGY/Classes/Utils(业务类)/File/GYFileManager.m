//
//  GYFileManager.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/4.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYFileManager.h"

/*
 NSFileManager
 抽取一个业务类，专门处理某项业务逻辑
 为什么高框架思想(MVC、MVCS、MVVM、MVP、VIPER)
 1. 让代码业务逻辑比较清晰
 2. 让一个类中代码不要太多
 
 MVCS：
 S:service服务，业务，工具类，专门处理墨香业务逻辑
 使用场景：
 1. 处理文件
 2. 网络业务类，专门去加载网络
 3. 离线缓存业务类
 4. App配置业务
 */

@implementation GYFileManager

+ (void)getDirectorySize:(NSString*)dirPath completion:(void(^)(NSInteger))completion{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1. 获取cache文件夹路径void
        NSString *cachePath = dirPath;
        
        // 2. 获取文件管理者
        NSFileManager *manager = [NSFileManager defaultManager];
        //-------------
        BOOL isDirectory;
        BOOL isExists = [manager fileExistsAtPath:cachePath isDirectory:&isDirectory];
        if(!isExists || !isDirectory) {
            //报错：抛出异常
            NSException *exception = [NSException exceptionWithName:@"参数错误" reason:@"传入路径不存在，或者不是文件夹！" userInfo:nil];
            @throw exception;
            //[exception raise];
        }
        //-------------
        // 3. 获取文件夹所有子路径数组：获取多级路径下文件路经
        NSArray *subPathes = [manager subpathsAtPath:cachePath];
        
        NSInteger size = 0;
        for (NSString *subPath in subPathes) {
            NSString *filePath = [cachePath stringByAppendingPathComponent:subPath];
            NSDictionary *dict = [manager attributesOfItemAtPath:filePath error:nil];
            // 判断是否是隐藏文件
            if([filePath containsString:@".DS"])    continue;
            // 判断是否是文件夹
            BOOL isDirectory;
            BOOL isExists = [manager fileExistsAtPath:filePath isDirectory:&isDirectory];
            if(!isExists || isDirectory)           continue;
            
            size += [dict fileSize];
        }
        
        if(completion) {
            completion(size);
        }
    });
    
}


+ (void)getDirectorySizeStr:(NSString*)dirPath completion:(void(^)(NSString*))completion{
    [self getDirectorySize:dirPath completion:^(NSInteger size) {
        NSString *str = nil;
        if(size >= 1000000) {
            str = [NSString stringWithFormat:@"%.1fMB", size / 1000000.0];
        } else if(size >= 1000) {
            str = [NSString stringWithFormat:@"%.1fKB", size / 1000.0];
        } else {
            str = [NSString stringWithFormat:@"%ldB", size];
        }
        
        str = [str stringByReplacingOccurrencesOfString:@".0" withString:@""];
        
        if(completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(str);
            });
         }
    }];
}



+ (NSInteger)directorySize:(NSString*)dirPath {
    // 1. 获取cache文件夹路径
    NSString *cachePath = dirPath;
    
    // 2. 获取文件管理者
    NSFileManager *manager = [NSFileManager defaultManager];
    //-------------
    BOOL isDirectory;
    BOOL isExists = [manager fileExistsAtPath:cachePath isDirectory:&isDirectory];
    if(!isExists || !isDirectory) {
        //报错：抛出异常
        NSException *exception = [NSException exceptionWithName:@"参数错误" reason:@"传入路径不存在，或者不是文件夹！" userInfo:nil];
        @throw exception;
        //[exception raise];
        
    }
    //-------------
    // 3. 获取文件夹所有子路径数组：获取多级路径下文件路经
    NSArray *subPathes = [manager subpathsAtPath:cachePath];
    
    NSInteger size = 0;
    for (NSString *subPath in subPathes) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:subPath];
        NSDictionary *dict = [manager attributesOfItemAtPath:filePath error:nil];
        // 判断是否是隐藏文件
        if([filePath containsString:@".DS"])    continue;
        // 判断是否是文件夹
        BOOL isDirectory;
        BOOL isExists = [manager fileExistsAtPath:filePath isDirectory:&isDirectory];
        if(!isExists || isDirectory)           continue;
        
        size += [dict fileSize];
    }
    return size;
}

+ (NSString*)directorySizeStr:(NSString*)dirPath {
    NSInteger size = [self directorySize:dirPath];
    
    NSString *str = nil;
    if(size >= 1000000) {
        str = [NSString stringWithFormat:@"%.1fMB", size / 1000000.0];
    } if(size >= 1000) {
        str = [NSString stringWithFormat:@"%.1fKB", size / 1000.0];
    } else {
        str = [NSString stringWithFormat:@"%ldB", size];
    }
    
    return str;
}

+ (void)removeDirectory:(NSString*)dirPath {
    NSString *cachePath = dirPath;
    [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
