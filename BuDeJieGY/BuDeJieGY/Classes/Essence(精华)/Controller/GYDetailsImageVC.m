//
//  GYDetailsImageVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYDetailsImageVC.h"
#import <Photos/Photos.h>

#import "../../Utils(业务类)/Photo/GYPhotoManager.h"

#define SRHAlbumName    @"仿百思不得姐"

/**
 如何学习已给你的框架 (百度)
 1. 了解这个框架有那些常用的类 (去头文件)
 2. 查看苹果苹果官方文档
 */

/**
 PHPhotoLibrary     相簿(所有图片的集合)
 PHAsset            可理解为图片
 PHAssetCollection  相册
 PHAssetChangeRequest 创建、修改、删除图片
 PHAssetCollectionChangeRequest 创建、修改、删除相册
 */

@interface GYDetailsImageVC () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (weak, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSString *imageKey;
@property (assign, nonatomic) BOOL scrollViewIsScrolling;
@end

@implementation GYDetailsImageVC

//- (UIImageView *)imageView {
//    if(_imageView == nil) {
//        _imageView = [[UIImageView alloc] init];
//    }
//    return _imageView
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)savePhoto {
    [GYPhotoManager savePhoto:_imageView.image albumTitle:SRHAlbumName completionHandle:^(NSError * _Nonnull error, NSString * _Nonnull localIndentifier) {
        GYLog(@"%@", localIndentifier);
        if(error) {
            [SVProgressHUD showErrorWithStatus:@"保存相片出错！"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"保存相片成功！"];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }];
}

- (IBAction)saveImageClick:(UIButton *)sender {
    /**
     PHAuthorizationStatusNotDetermined  不确定
     PHAuthorizationStatusRestricted 家长控制
     PHAuthorizationStatusDenied 拒绝
     PHAuthorizationStatusAuthorized 授权
     */
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized) {
                [self savePhoto];
            }
        }];
    } else if(status == PHAuthorizationStatusAuthorized) {
        [self savePhoto];
    } else {
        [SVProgressHUD showInfoWithStatus:@"请进入设置界面->找到相应的应用->打开允许访问相册的开关"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
    
    //UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:_imageKey];
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //UIImageWriteToSavedPhotosAlbum(_imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

//- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
//    if(error) {
//        [SVProgressHUD showErrorWithStatus:@"保存失败！"];
//    } else {
//        [SVProgressHUD showSuccessWithStatus:@"保存成功！"];
//    }
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [SVProgressHUD dismiss];
//    });
//}

- (instancetype)initWithTopicItem:(GYTopicItem*)item {
    self = [self init];
    if (self) {
        _topicItem = item;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *imageView = ({
        CGFloat imageWidth = 0;
        CGFloat imageHeight = 0;
        if(_topicItem.image) {
            imageWidth = _topicItem.image.width;
            imageHeight = _topicItem.image.height;
        } else if(_topicItem.gif) {
            imageWidth = _topicItem.gif.width;
            imageHeight = _topicItem.gif.height;
        }
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat width = self.scrollView.width;
        CGFloat height = width * imageHeight / imageWidth;
        if(height < self.scrollView.height) {
            y = (self.scrollView.height - height) / 2.0;
        }
        //====================================
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(x, y, width, height);
        [_scrollView addSubview:imageView];
        _scrollView.contentSize = CGSizeMake(0, height);
        
        CGFloat maxScale = imageWidth / width;
        if (maxScale > 1.0) { // 增加放大功能
            _scrollView.maximumZoomScale = maxScale;
            _scrollView.delegate = self;
        }
        imageView;
    });
    _imageView = imageView;
    //====================================
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    tap.delegate = self;
    [_scrollView addGestureRecognizer:tap];
    //===================================
    NSURL *url = nil;
    if(_topicItem.image) {
        _imageKey = _topicItem.image.big[0];
    } else if(_topicItem.gif) {
        _imageKey = _topicItem.gif.images[0];
    }
    
    url = [NSURL URLWithString:_imageKey];

    [_imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if(expectedSize > 0) {
            CGFloat progress = 1.0 * receivedSize / expectedSize;
            self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f", 100.0 * progress];
            [self.progressView setProgress:progress animated:YES];
        }
        
    } completed:nil];

}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _scrollViewIsScrolling = YES;
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    _scrollViewIsScrolling = YES;
//}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    _scrollViewIsScrolling = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _scrollViewIsScrolling = NO;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _scrollViewIsScrolling = NO;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (_scrollViewIsScrolling) {
        return NO;
    }
    return YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
