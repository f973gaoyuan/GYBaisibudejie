//
//  GYBaseEssenceVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/5.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYBaseContentVC.h"


CGFloat const baseScale     = 0.1;
CGFloat const colorNorValue = 160 / 255.0;
CGFloat const colorSelValue = 0 / 255.0;
#define kTitleColor

@interface GYBaseContentVC () <UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray<UIButton*> *titleBtns;
@property (weak, nonatomic) UIButton *selectBtn;
@property (weak, nonatomic) UIScrollView *titleScrollView;
@property (weak, nonatomic) UIScrollView *contentScrollView;
@property (strong, nonatomic) UIColor *normalColor;
@property (strong, nonatomic) UIColor *selectColor;
@property (assign, nonatomic) BOOL isInitialize;
@end

@implementation GYBaseContentVC
- (NSMutableArray<UIButton *> *)titleBtns {
    if(_titleBtns == nil) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

- (UIColor *)normalColor {
    if(_normalColor == nil) {
        _normalColor = [UIColor colorWithWhite:colorNorValue alpha:1];
    }
    return _normalColor;
}

- (UIColor *)selectColor {
    if(_selectColor == nil) {
        _selectColor = [UIColor colorWithWhite:colorSelValue alpha:1];
    }
    return _selectColor;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   _toolBarHeight = 44;
    [self setupTitleScrollView];
    [self setupContentScrollView];
    //[self setupAllViewController];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat width = self.contentScrollView.width;
        NSInteger count = self.childViewControllers.count;
        self.contentScrollView.contentSize = CGSizeMake(width * count, 0);
        [self setupAllTitle];
    });
}
#pragma mark - 标题居中
- (void)setTitleCenter:(UIButton*)btn{
    CGFloat offset = btn.center.x - _titleScrollView.width * 0.5;
    CGFloat max = _titleScrollView.contentSize.width - _titleScrollView.width;
    
    if(offset < 0) {
        offset = 0;
    }
    
    if(offset > max) {
        offset = max;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.titleScrollView.contentOffset = CGPointMake(offset, 0);
    }];
}
#pragma mark - 选中标题
- (void)selectBtn:(UIButton*)btn {
    [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
    [_selectBtn setTitleColor:self.normalColor forState:UIControlStateNormal];
    
    _selectBtn.transform = CGAffineTransformIdentity;
    [_selectBtn setSelected:NO];
    [btn setSelected:YES];
    _selectBtn = btn;
    
    [self setTitleCenter:btn];
    
     _selectBtn.transform = CGAffineTransformMakeScale(1+baseScale, 1+baseScale);
}
#pragma mark - 标题点击
- (void)titleClick:(UIButton*)btn {
    [self selectBtn:btn];

    NSInteger index = btn.tag;
    [self setupViewWithIndex:index];

    CGFloat width = _contentScrollView.width;
    CGFloat offset = index * width;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = CGPointMake(offset, 0);
     }];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = _contentScrollView.width;
    NSInteger index = _contentScrollView.contentOffset.x / width;
    
    [self titleClick:_titleBtns[index]];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger width = scrollView.width;
    NSInteger leftI  = scrollView.contentOffset.x / width;
    NSInteger rightI = leftI+1;
    
    UIButton *leftBtn = _titleBtns[leftI];
    UIButton *rightBtn = nil;
    if(rightI < _titleBtns.count) {
        rightBtn = _titleBtns[rightI];
    }
    
    CGFloat scaleR = (scrollView.contentOffset.x / width) - leftI;
    CGFloat scaleL = 1 - scaleR;
    
    //211    211    211
    leftBtn.transform = CGAffineTransformMakeScale(1 + baseScale * scaleL, 1 + baseScale * scaleL);
    rightBtn.transform = CGAffineTransformMakeScale(1 + baseScale * scaleR, 1 + baseScale * scaleR);
    

    CGFloat del = colorSelValue - colorNorValue;
    
    CGFloat valueL = colorNorValue + del * scaleL;
    CGFloat valueR = colorNorValue + del * scaleR;

    UIColor *colorL = [UIColor colorWithWhite:valueL alpha:1];
    UIColor *colorR = [UIColor colorWithWhite:valueR alpha:1];
    
    [leftBtn setTitleColor:colorL forState:UIControlStateNormal];
    [rightBtn setTitleColor:colorR forState:UIControlStateNormal];
}


#pragma mark - 设置标题ScrollView
- (void)setupTitleScrollView {
    NSInteger y = 20;
    if(self.navigationController && self.navigationController.navigationBarHidden == NO) {
        y += 44;
    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, GYScreenW, _toolBarHeight)];
    [self.view addSubview:scrollView];
    _titleScrollView = scrollView;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
}
#pragma mark - 设置内容ScrollView
- (void)setupContentScrollView {
    NSInteger y = CGRectGetMaxY(_titleScrollView.frame);
    CGFloat height = CGRectGetMaxY(self.view.frame)-y;
//    if(self.tabBarController && self.tabBarController.tabBar.hidden == NO) {
//        height -= 49;
//    }
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, GYScreenW, height)];
    [self.view addSubview:scrollView];
    _contentScrollView = scrollView;
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = YES;
    scrollView.delegate = self;
}

#pragma mark - 设置内容视图控制器标题
- (void)setupAllTitle {
    NSInteger count = self.childViewControllers.count;
    NSInteger btnWidth = 100;
    NSInteger btnHeight = _titleScrollView.height;

    CGRect frame = CGRectMake(0, 0, btnWidth, btnHeight);
    for(NSInteger i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        btn.frame = frame;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];

        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleBtns addObject:btn];
        [_titleScrollView addSubview:btn];
        
        frame.origin.x += btnWidth;
    }
    
    _titleScrollView.contentSize = CGSizeMake(btnWidth * count, 0);
    [self titleClick:_titleBtns[0]];
}
#pragma mark - 添加控制器view到contentScrollView
- (void)setupViewWithIndex:(NSInteger)index {
    NSInteger count = self.childViewControllers.count;
    if(index >= count)  {
        @throw [NSException exceptionWithName:@"子控制器索引值错误!" reason:@"子控制器索引值超出最大值范围" userInfo:nil];
    }
    UIView *view = self.childViewControllers[index].view;
    CGRect frame = _contentScrollView.bounds;
    frame.origin.x = _contentScrollView.width * index;
    view.frame = frame;
    [_contentScrollView addSubview:view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
