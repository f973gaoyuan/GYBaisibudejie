//
//  GYPhotoManager.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/20.
//  Copyright © 2019 gaoyuan. All rights reserved.
//Photo

#import "GYPhotoManager.h"
#import <Photos/Photos.h>

@implementation GYPhotoManager
+ (PHAssetCollectionChangeRequest*)getCurrentPhotoCollectionWithAlbumName:(NSString*)albumName {
    //1. 创建搜索集合
    PHFetchResult *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //2. 遍历搜索集合取出对应的相册，返回当前相册的changeRequest
    for (PHAssetCollection *assetCollection in fetchResult) {
        if([assetCollection.localizedTitle isEqualToString:albumName]) {
            PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
            return collectionRequest;
        }
    }
    //3. 如果不存在，创建一个名字为albumName的相册changeRequest
    PHAssetCollectionChangeRequest *collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
    return collectionRequest;
}

+ (void)savePhoto:(UIImage*)image albumTitle:(NSString*)albumTitle completionHandle:(void(^)(NSError *error, NSString *localIndentifier))completionHandler {
    // 1. 获取照片对象库
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    // 假如外面需要这个 localIndentifier, 可以通过block传出去
    __block NSString *localIndentifier = @"";
    
    // 2. 调用changeblock
    [library performChanges:^{
        // 2.1 创建一个相册变动请求
        PHAssetCollectionChangeRequest *collectionRequest = [self getCurrentPhotoCollectionWithAlbumName:albumTitle];
        // 2.2 根据传入的照片，创建照片变动请求
        PHAssetChangeRequest *assertRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        // 2.3 创建一个占位对象
        PHObjectPlaceholder *placeHolder = [assertRequest placeholderForCreatedAsset];
        localIndentifier = placeHolder.localIdentifier;
        // 2.4 将占位对象添加到相册中
        [collectionRequest addAssets:@[placeHolder]];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error) {
                //GYLog(@"保存照片出错>>>%@", [error description]);
                completionHandler(error, nil);
            } else {
                completionHandler(nil, localIndentifier);
            }
        });
    }];
    
}

@end
