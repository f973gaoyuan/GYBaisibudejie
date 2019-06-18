//
//  GYDetailsImageVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/18.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYDetailsImageVC.h"
#import "../Model/GYTopicItem.h"

@interface GYDetailsImageVC () <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (weak, nonatomic) UIImageView *imageView;
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
    if(_topicItem.image)    url = [NSURL URLWithString:_topicItem.image.big[0]];
    else if(_topicItem.gif) url = [NSURL URLWithString:_topicItem.gif.images[0]];

    [_imageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if(expectedSize > 0) {
            CGFloat progress = 1.0 * receivedSize / expectedSize;
            self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f", 100.0 * progress];
            [self.progressView setProgress:progress animated:YES];
        }
        
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//        //self.imageView.image = image;
//        //[self viewDidLayoutSubviews];
//        CGSize imageSize = image.size;
//
//        CGFloat x = 0;
//        CGFloat y = 0;
//        CGFloat width = self.scrollView.width;
//        CGFloat height = width * imageSize.height / imageSize.width;
//
//        if(height < self.scrollView.height) {
//            y = (self.scrollView.height - height) / 2.0;
//        }
//
//        self.imageView.frame = CGRectMake(x, y, width, height);
//        self.scrollView.contentSize = CGSizeMake(0, height);
   }];

}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _scrollViewIsScrolling = YES;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
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
