//
//  GYEssenceContentVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/5.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYEssenceContentVC.h"
static NSString * const ID = @"contentCell";
static CGFloat const baseScale     = 0.1;
static CGFloat const colorNorValue = 160 / 255.0;
static CGFloat const colorSelValue = 0 / 255.0;

@interface GYEssenceContentVC () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray<UIButton*> *titleBtns;
@property (weak, nonatomic) UIButton *selectBtn;
@property (weak, nonatomic) UIView *underLine;
@property (weak, nonatomic) UIScrollView *titleViewGY;
@property (weak, nonatomic) UICollectionView *contentViewGY;
@property (strong, nonatomic) UIColor *normalColor;
@property (strong, nonatomic) UIColor *selectColor;
@property (assign, nonatomic) BOOL isInitialize;
@end

@implementation GYEssenceContentVC
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
    if(!_isInitialize) {
        //CGFloat width = self.contentViewGY.width;
        //NSInteger count = self.childViewControllers.count;
        //self.contentViewGY.contentSize = CGSizeMake(width * count, 0);
        [self setupAllTitle];
        _isInitialize = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _toolBarHeight = 44;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupContentView];
    [self setupTitleView];
    
 }
#pragma mark - 标题居中
- (void)setTitleCenter:(UIButton*)btn{
    CGFloat offset = btn.center.x - _titleViewGY.width * 0.5;
    CGFloat max = _titleViewGY.contentSize.width - _titleViewGY.width;
    
    if(offset < 0) {
        offset = 0;
    }
    
    if(offset > max) {
        offset = max;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.titleViewGY.contentOffset = CGPointMake(offset, 0);
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
    
    [UIView animateWithDuration:0.25 animations:^{
        CGPoint center0 = btn.center;
        CGPoint center1 = self.underLine.center;
        center1.x = center0.x;
        self.underLine.center = center1;
    }];
    
    NSInteger index = btn.tag;
    CGFloat width = _contentViewGY.width;
    CGFloat offset = index * width;
    self.contentViewGY.contentOffset = CGPointMake(offset, 0);
//    [UIView animateWithDuration:0.3 animations:^{
//        self.contentViewGY.contentOffset = CGPointMake(offset, 0);
//    }];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UITableViewController *vc = self.childViewControllers[indexPath.row];
    vc.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.titleViewGY.frame), 0, 49, 0);
    vc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:vc.view];
    
    return cell;
}
#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat width = scrollView.width;
    NSInteger page = scrollView.contentOffset.x / width;
    //[self titleClick:_titleBtns[page]];
    [self selectBtn:_titleBtns[page]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat width = scrollView.width;
    NSInteger leftI = scrollView.contentOffset.x / width;
    NSInteger rightI = leftI + 1;
    
    UIButton *leftBtn = _titleBtns[leftI];
    UIButton *rightBtn = nil;
    if(rightI < _titleBtns.count) {
        rightBtn = _titleBtns[rightI];
    }
    
    CGFloat scaleR = scrollView.contentOffset.x / width - leftI;
    CGFloat scaleL = 1 - scaleR;
    ///////////////////////
    //设置缩放
    leftBtn.transform = CGAffineTransformMakeScale(1 + baseScale * scaleL, 1 + baseScale * scaleL);
    rightBtn.transform = CGAffineTransformMakeScale(1 + baseScale * scaleR, 1 + baseScale * scaleR);
    ///////////////////////
    //设置颜色
    CGFloat del = colorSelValue - colorNorValue;
    CGFloat valueL = colorNorValue + scaleL * del;
    CGFloat valueR = colorNorValue + scaleR * del;
    
    [leftBtn setTitleColor:[UIColor colorWithWhite:valueL alpha:1] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithWhite:valueR alpha:1] forState:UIControlStateNormal];
    ///////////////////////
    //设置underline
    CGFloat deltaX = rightBtn.center.x - leftBtn.center.x;
    if(rightBtn == nil) {
        UIButton *btn = _titleBtns[leftI-1];
        deltaX = leftBtn.center.x - btn.center.x;
    }

    CGPoint center0 = leftBtn.center;
    CGPoint center1 = self.underLine.center;
    center1.x = center0.x + deltaX * scaleR;
    self.underLine.center = center1;
}
#pragma mark - 设置标题视图
- (void)setupTitleView {
    NSInteger y = 20;
    if(self.navigationController && self.navigationController.navigationBarHidden == NO) {
        y += 44;
    }
    UIColor *color = [UIColor colorWithWhite:1 alpha:0.9];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GYScreenW, 20)];
    view.backgroundColor = color;
    [self.view addSubview:view];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, GYScreenW, _toolBarHeight)];
    scrollView.backgroundColor = color;
    [self.view addSubview:scrollView];
    _titleViewGY = scrollView;
    
    //scrollView.backgroundColor = [UIColor redColor];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
}

#pragma mark - 设置内容视图控制器标题
- (void)setupContentView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *contentView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, GYScreenW, GYScreenH) collectionViewLayout:flowLayout];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.dataSource = self;
    contentView.delegate = self;
    contentView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.pagingEnabled = YES;
    [contentView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:ID];
    [self.view addSubview:contentView];
    _contentViewGY = contentView;
    
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.pagingEnabled = YES;
//    scrollView.bounces = YES;
//    scrollView.delegate = self;
}
#pragma mark - 设置内容视图控制器标题
- (void)setupAllTitle {
    NSInteger count = self.childViewControllers.count;
    NSInteger btnWidth = 100;
    NSInteger btnHeight = _titleViewGY.height;
    
    CGRect frame = CGRectMake(0, 0, btnWidth, btnHeight);
    for(NSInteger i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        btn.frame = frame;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        
        CGFloat fontSize = 0.409 * btnHeight;
        btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if(i == 0) {
            [btn.titleLabel sizeToFit];
            CGFloat width = btn.titleLabel.width * 0.6;
            CGFloat height = 2;
            CGFloat y = btnHeight - height - 1;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, height)];
            view.backgroundColor = [UIColor redColor];
            [_titleViewGY addSubview:view];
            _underLine = view;
        }
        
        [self.titleBtns addObject:btn];
        [_titleViewGY addSubview:btn];
        
        frame.origin.x += btnWidth;
    }
    
    _titleViewGY.contentSize = CGSizeMake(btnWidth * count, 0);
    [self titleClick:_titleBtns[0]];
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
