//
//  GYHeaderRefreshView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/23.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYHeaderRefreshView.h"

@interface GYHeaderRefreshView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIView *refreshDataView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GYHeaderRefreshView
- (void)setNeedRefresh:(BOOL)needRefresh {
    _needRefresh = needRefresh;
    
    _textLabel.text = needRefresh ? @"松开即可刷新" : @"下拉可以刷新";
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.transform = needRefresh ? CGAffineTransformMakeRotation(-M_PI+0.0001) : CGAffineTransformIdentity;
    }];
}

- (void)setLoadData:(BOOL)loadData {
    _loadData = loadData;
    if(loadData) {
        _refreshDataView.hidden = NO;
        [_activityIndicator startAnimating];
    } else {
        _refreshDataView.hidden = YES;
        [_activityIndicator stopAnimating];
        [self setNeedRefresh:NO];
    }
}

+ (instancetype)headerRefreshView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.backgroundColor = GYColor(240, 240, 240);
    self.refreshDataView.backgroundColor = GYColor(240, 240, 240);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
