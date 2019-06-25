//
//  GYBottomRefreshView.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/21.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYFooterRefreshView : UIView
//@property (assign, nonatomic) BOOL isRefreshData;
@property (assign, nonatomic, getter=isRefreshData) BOOL refreshData;
+ (instancetype)footerRefreshView;
@end

NS_ASSUME_NONNULL_END
