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

@property (strong, nonatomic) NSMutableArray *imageViewArray;
@property (strong, nonatomic) UIImage *image;

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
//            if(imageHeight > 20000) {
//                GYLog(@"%.1f , %.1f", imageWidth, imageHeight);
//                GYLog(@"%@", _topicItem.image.big[0]);
//            }
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
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f", 100.0 * progress];
                [self.progressView setProgress:progress animated:YES];
            });
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat dispW = self.scrollView.width;
        CGFloat dispH = dispW * image.size.height / image.size.width;
        if(dispH > self.scrollView.height) {
            [self setupImageViewArrayWithImage:image];
            [self.imageView removeFromSuperview];
       }
    }];
}

- (NSMutableArray *)imageViewArray {
    if(_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (void)setupImageViewArrayWithImage:(UIImage*)image {
    [self.imageViewArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.imageViewArray removeAllObjects];
    if (!image) {
        return;
    }
    
    CGFloat dispW = _scrollView.width;
    CGFloat dispH = _scrollView.height;
    
    CGFloat imageWidth  = image.size.width;     // 图片宽度
    CGFloat imageHeight = image.size.height;    // 图片高度
    CGFloat imageHeightPerScreen = imageWidth * dispH / dispW; // 每屏图片实际高度
    
    //NSInteger count = ceil(imageHeight / imageHeightPerScreen);
    //NSInteger count = floor(imageHeight / imageHeightPerScreen);
    CGFloat surplus = imageHeight;
    CGFloat y0 = 0;
    CGFloat yf = 0;
    while(surplus > imageHeightPerScreen) {
        CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, y0, imageWidth, imageHeightPerScreen));
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imgRef]];
        imageView.frame = CGRectMake(0, yf, dispW, dispH);
 
        [self.imageViewArray addObject:imageView];
        [_scrollView addSubview:imageView];
        
        surplus -= imageHeightPerScreen;
        y0 += imageHeightPerScreen;
        yf += dispH;
    }
    
    if(surplus > 0) {
        CGFloat imgH = surplus * dispW / imageWidth;
        CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, y0, imageWidth, surplus));
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imgRef]];
        imageView.frame = CGRectMake(0, yf, dispW, imgH);
        
        [self.imageViewArray addObject:imageView];
        [_scrollView addSubview:imageView];
        yf += imgH;

        /*
        CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, y0, imageWidth, surplus));
        UIImage *smallImage = [UIImage imageWithCGImage:imgRef];
        
        CGFloat imgH = surplus * dispW / imageWidth;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeightPerScreen), 1, 0);
        UIBezierPath *fillPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, imageWidth, imageHeightPerScreen)];
        GYColor(0, 0, 0).set;
        [fillPath fill];
        
        [smallImage drawInRect:CGRectMake(0, 0, dispW, imgH)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
        imageView.frame = CGRectMake(0, yf, dispW, dispH);
        [self.imageViewArray addObject:imageView];
        yf += imgH;//_scrollView.height;
         */
    }
    _scrollView.contentSize = CGSizeMake(0, yf);
}
/*
- (void)setImage:(UIImage *)image {
    _image = image;
    
    [self.imageViewArray enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.imageViewArray removeAllObjects];
    if (!image) {
        return;
    }
    
    CGFloat imageWidth = image.size.width;
    CGFloat maxImageHeight = imageWidth * self.maxHeightFator;
    if (maxImageHeight == 0) {
        return;
    }
    NSInteger count = ceil(image.size.height / maxImageHeight);
    
    for (NSInteger index = 0; index < count; ++ index) {
        CGFloat height = (index == count - 1) ? image.size.height - maxImageHeight * index : maxImageHeight;
        CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, index * maxImageHeight, imageWidth, height));
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imgRef]];
        view.contentMode = self.contentMode;
        [self addSubview:view];
        [self.imageViewArray addObject:view];
    }
    [self setNeedsLayout];
}

---------------------
作者：weixin_34019929
来源：CSDN
原文：https://blog.csdn.net/weixin_34019929/article/details/87405757
版权声明：本文为博主原创文章，转载请附上博文链接！
*/
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
