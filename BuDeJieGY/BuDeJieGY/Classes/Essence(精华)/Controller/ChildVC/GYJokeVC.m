//
//  GYJokeVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/5.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYJokeVC.h"

@interface GYJokeVC ()

@end

@implementation GYJokeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadTopicDataWithIndex:GYEssenceNetDataTypeJoke];
}
@end
