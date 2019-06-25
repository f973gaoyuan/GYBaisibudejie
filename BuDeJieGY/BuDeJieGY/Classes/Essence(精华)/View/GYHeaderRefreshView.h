//
//  GYHeaderRefreshView.h
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/23.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYHeaderRefreshView : UIView
@property (assign, nonatomic, getter=isNeedRefresh) BOOL needRefresh;
@property (assign, nonatomic, getter=isLoadData) BOOL loadData;
+ (instancetype)headerRefreshView;
@end

NS_ASSUME_NONNULL_END
