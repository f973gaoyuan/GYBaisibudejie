//
//  UIView+Fetch.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/27.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "UIView+Fetch.h"

@implementation UIView (Fetch)
- (UITableView *)fetchChildView {
    UITableView *tableView = nil;
    for (UIView *childView in self.subviews) {
        if([childView isKindOfClass:UITableView.class]) {
            tableView = (UITableView*)childView;
        }
        UITableView *tableViewTmp = [childView fetchChildView];
        if(tableViewTmp) {
            tableView = tableViewTmp;
        }
    }
    return tableView;
}
@end
