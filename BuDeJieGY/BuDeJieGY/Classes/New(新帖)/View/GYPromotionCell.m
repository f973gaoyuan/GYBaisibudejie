//
//  GYPromotionCell.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/22.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYPromotionCell.h"
#import "../../Other/Category/UIView+frame.h"


@interface GYPromotionCell () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray<UIImageView*> *imageViewArray;
@property (weak, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSUInteger page;
@end

@implementation GYPromotionCell

+ (instancetype)promotionCell {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

- (NSMutableArray<UIImageView *> *)imageViewArray {
    if(_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

//- (void)setPage:(NSUInteger)page {
//    _page = page;
//
//    _scrollView.contentOffset = (page + 1) * 
//}

- (void)setItems:(NSArray<GYPromotionItem *> *)items {
    _items = items;
    [self setScrollViewSubViews];
}

- (void)setScrollViewSubViews {
    for (UIImageView *imageView in self.imageViewArray) {
        [imageView removeFromSuperview];
    }
    [self.imageViewArray removeAllObjects];
    //***************************************************
    CGFloat width = _scrollView.frame.size.width;
    NSUInteger count = _items.count;
    for(int i = 0; i < count + 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = _scrollView.frame;
        imageView.x = i * width;

        [_imageViewArray addObject:imageView];
        [_scrollView addSubview:imageView];
    }
    
    _scrollView.contentSize = CGSizeMake((count+2) * width, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    //***************************************************
    
    for(int i = 0; i < count; i++) {
        UIImageView *imageView = _imageViewArray[i+1];
        GYPromotionItem *item = _items[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.image] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(i == 0) {
                UIImageView *obj = self.imageViewArray[count+1];
                obj.image = image;
            } else if(i == count-1) {
                UIImageView *obj = self.imageViewArray[0];
                obj.image = image;
            }
        }];
    }
    
    _scrollView.contentOffset = CGPointMake(width, 0) ;
    [_pageControl setCurrentPage:0];
    _page = 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _scrollView.delegate = self;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(self.items != nil) {
            CGFloat offset = self.scrollView.contentOffset.x;
            CGFloat width = self.scrollView.width;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.scrollView.contentOffset = CGPointMake(offset + width, 0);
            } completion:^(BOOL finished) {
                [self setScrollViewPos:self.scrollView];
            }];
        }
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)dealloc
{
    [_timer invalidate];
}

- (void) setScrollViewPos:(UIScrollView *)scrollView  {
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat width = scrollView.width;
    NSInteger count = _items.count;
    NSInteger page = offset / width;
    NSInteger index = page;
    if(page == 0) {
        index = count;
    } else if (page == count+1) {
        index = 1;
    }
    
    scrollView.contentOffset = CGPointMake(index * width, 0) ;
    [_pageControl setCurrentPage:(index-1)];
    _page = (index-1);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {      // called when scroll view grinds to a halt
    [self setScrollViewPos:scrollView];
}
@end
