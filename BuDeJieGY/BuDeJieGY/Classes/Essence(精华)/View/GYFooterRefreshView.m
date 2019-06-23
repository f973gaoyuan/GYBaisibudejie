//
//  GYBottomRefreshView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/21.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYFooterRefreshView.h"

@interface GYFooterRefreshView ()
@property (weak, nonatomic) IBOutlet UIView *moreDataView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation GYFooterRefreshView

- (void)setRefreshData:(BOOL)refreshData {
    _refreshData = refreshData;
    _moreDataView.hidden = !refreshData;
    
    if(refreshData) {
        [_activityIndicator startAnimating];
    } else {
        [_activityIndicator stopAnimating];
    }
}

+ (instancetype)bottomRefreshView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil][0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = GYColor(240, 240, 240);
    self.moreDataView.backgroundColor = GYColor(240, 240, 240);
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
