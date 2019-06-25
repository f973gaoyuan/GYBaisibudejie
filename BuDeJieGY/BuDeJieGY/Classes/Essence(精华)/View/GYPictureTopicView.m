//
//  GYPictureTopicView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/11.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYPictureTopicView.h"

//#import "../../Utils(业务类)/ImageBrowsing/BBSImageBrowsingController.h"
#import "../Controller/GYDetailsImageVC.h"


@interface GYPictureTopicView ()
@property (weak, nonatomic) IBOutlet UIImageView *gifSignGY;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewGY;
@property (weak, nonatomic) IBOutlet UILabel *typelabel;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (assign, nonatomic) BOOL isLongPic;
@end

@implementation GYPictureTopicView
- (void)setTopicItem:(GYTopicItem *)topicItem {
    _topicItem = topicItem;
    
    _progressView.progress = 0;
    _progressView.progressLabel.text = @"0.0%";
    _isLongPic = NO;
    _typelabel.hidden = YES;

    if([topicItem.type isEqualToString:@"image"]) {
        [self setupImageData];
    } else if([topicItem.type isEqualToString:@"gif"]) {
        [self setupGifData];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSURL *url = nil;
    if([_topicItem.type isEqualToString:@"image"]) {
        url = [NSURL URLWithString:_topicItem.image.big[0]];
    } else if([_topicItem.type isEqualToString:@"gif"]) {
        url = [NSURL URLWithString:_topicItem.gif.images[0]];
    } else {
        return;
    }
    GYDetailsImageVC *vc = [[GYDetailsImageVC alloc] initWithTopicItem:_topicItem];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:vc animated:YES completion:nil];
    
    //NSArray *array = @[self.detailsImageView];
    //BBSImageBrowsingController *browsingController = [[BBSImageBrowsingController alloc] initWithImageViewArray:array currentIndex:0];
    //[[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:browsingController animated:YES completion:nil];
}

- (void)setupImageData{
    NSURL *url = [NSURL URLWithString:_topicItem.image.big[0]];
    [_imageViewGY sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if(expectedSize > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat progress = 1.0 * receivedSize / expectedSize;
                //self.progressView.progress = progress;
                self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.1f%%", 100.0 * progress];
                [self.progressView setProgress:progress animated:YES];
                //GYLog(@"progress = %.2f", progress);
            });
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        // 原图片 尺寸
        CGFloat W0 = self.topicItem.image.width;
        CGFloat H0 = self.topicItem.image.height;
        // 绘图尺寸
        CGFloat DrawW = W0;
        CGFloat DrawH = H0;
        CGFloat WScaleH = 1;
        if(DrawH > DrawW*WScaleH) {
            DrawH = DrawW*WScaleH;
            self.isLongPic = YES;
            self.typelabel.text = @"长图";
        }
        self.typelabel.hidden = !self.isLongPic;

        UIGraphicsBeginImageContextWithOptions(CGSizeMake(DrawW, DrawH), 0, 0);
        [image drawInRect:CGRectMake(0, 0, W0, H0)];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.imageViewGY.image = newImage;
        self.imageViewGY.layer.cornerRadius = 0;
        
//        if(H0 > 20000) {
//            NSString *fileName = [NSString stringWithFormat:@"%@.png", self.topicItem.ID];
//            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//            NSString *filePath = [cacheDir stringByAppendingPathComponent:fileName];
//            NSData *data = UIImagePNGRepresentation(image);
//            BOOL isError = [data writeToFile:filePath atomically:YES];
//            GYLog(@"....................%d", isError);
//       }
    }];
}

- (void)setupGifData{
    NSURL *url = [NSURL URLWithString:_topicItem.gif.images[0]];
    [_imageViewGY sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if(expectedSize > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat progress = 1.0 * receivedSize / expectedSize;
                //self.progressView.progress = progress;
                self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.1f%%", 100.0 * progress];
                [self.progressView setProgress:progress animated:YES];
            });
        }
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.typelabel.hidden = NO;
        self.typelabel.text = @"gif";
    }];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    _typelabel.layer.cornerRadius = 12;
    _typelabel.clipsToBounds = YES;
    
    _progressView.roundedCorners = YES;
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressLabel.textColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
