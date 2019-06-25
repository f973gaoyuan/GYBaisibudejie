//
//  GYNetworkingManager.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/21.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYNetworkingManager.h"



@interface GYNetworkingManager ()
@property (strong, nonatomic) GYADItem *startupADItem;
// 首页
@property (strong, nonatomic) NSMutableArray<GYTopicItem*> *recomTopics;   //  推荐
@property (strong, nonatomic) NSMutableArray<GYTopicItem*> *videoTopics;   //  视屏
@property (strong, nonatomic) NSMutableArray<GYTopicItem*> *pictureTopics; //  图片
@property (strong, nonatomic) NSMutableArray<GYTopicItem*> *jokeTopics;    //  笑话
@property (strong, nonatomic) NSMutableArray<GYTopicItem*> *enterTopics;   //  娱乐

@property (strong, nonatomic) NSArray *allTopicItems;
//===================================================
// 社区
@property (strong, nonatomic) NSArray<GYPromotionItem*> *promotions; // 社区推广
@property (strong, nonatomic) NSArray<GYSubscribeItem*> *subscribes; // 订阅数据
@property (strong, nonatomic) NSArray<GYHotSearchItem*> *hotSearches;// 热门搜索
//===================================================
// 关注
@property (strong, nonatomic) NSArray<GYRecommendFriendItem*> *recommendFriends; // 朋友推荐
@property (strong, nonatomic) NSMutableArray<GYTopicItem*> *friendTopics;       //  关注帖子
//===================================================
// 我的
@property (strong, nonatomic) NSMutableArray<GYSquareItem*> *squares;

@property (weak, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation GYNetworkingManager
#pragma mark - 懒加载
- (NSMutableArray<GYTopicItem *> *)recomTopics {
    if(_recomTopics == nil) {
        _recomTopics = [NSMutableArray array];
    }
    return _recomTopics;
}

- (NSMutableArray<GYTopicItem *> *)videoTopics {
    if(_videoTopics == nil) {
        _videoTopics = [NSMutableArray array];
    }
    return _videoTopics;
}

- (NSMutableArray<GYTopicItem *> *)pictureTopics {
    if(_pictureTopics == nil) {
        _pictureTopics = [NSMutableArray array];
    }
    return _pictureTopics;
}

- (NSMutableArray<GYTopicItem *> *)jokeTopics {
    if(_jokeTopics == nil) {
        _jokeTopics = [NSMutableArray array];
    }
    return _jokeTopics;
}

- (NSMutableArray<GYTopicItem *> *)enterTopics {
    if(_enterTopics == nil) {
        _enterTopics = [NSMutableArray array];
    }
    return _enterTopics;
}

- (NSMutableArray<GYTopicItem *> *)friendTopics {
    if(_friendTopics == nil) {
        _friendTopics = [NSMutableArray array];
    }
    return _friendTopics;
}

//- (NSMutableArray *)allTopicItems {
//    if(_allTopicItems == nil) {
//        _allTopicItems = [NSMutableArray array];
//    }
//    return _allTopicItems;
//}
- (AFHTTPSessionManager *)manager {
    if(_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        // 处理广告不显示
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        response.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"application/x-javascript", nil];
        _manager.responseSerializer = response;
       // _manager.responseSerializer = response;

        // https设置
        // 客户端是否信任非法证书
        _manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        [_manager.securityPolicy setValidatesDomainName:NO];
    }
    return _manager;
}
#pragma mark - 初始化
+ (instancetype)shareManager{
    static GYNetworkingManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[GYNetworkingManager alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //首页
        [GYTopicItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id",
                     @"user": @"u",
                     @"isBest": @"is_best"
                     };
        }];
        
        [GYCommentItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID" : @"id",
                     @"user": @"u"
                     };
        }];
        //关注
        [GYRecommendFriendItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];
        //我的
        [GYSquareItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID":@"id"};
        }];

        _allTopicItems = @[self.recomTopics, self.videoTopics, self.pictureTopics, self.jokeTopics, self.enterTopics];
    }
    return self;
}

- (void)cancelAllRequest {// 取消所有请求
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}
#pragma mark - 获取广告数据
// 请求数据 =》 接口文档 =》 AFN发送请求 =》 解析数据 =》 写成plisti=》 设计模型 =》 字典转模型 =》 直接把模型展示到界面
- (void)requestStartupADData:(void(^)(GYADItem *item, NSError * error))completionHandle {
    /*
     技巧：如果想知道一个类有哪些东西 --》 跳类
     想知道整个类做了什么，跳方法
     */
    //1. 创建请求绘画管理者
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager gy_manager];
    // 客户端是否信任非法证书
    //manager.securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    //[manager.securityPolicy setValidatesDomainName:NO];
    //2. 拼接参数
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    //    paramDict[@"code2"] = ADCODE;
    //    NSString *urlStr = @"http://mobads.baidu.com/cpro/ui/mads.php";
    //***********************************************************************
    /* 应用程序内广告
     NSString *urlStr = @"http://mi.gdt.qq.com/gdt_mview.fcg?posid=4010348307132921&ext=%7B%22req%22%3A%7B%22loc_accuracy%22%3A0%2C%22sdk_src%22%3A%22%22%2C%22muidtype%22%3A2%2C%22c_isjailbroken%22%3Afalse%2C%22jsver%22%3A%221.4.0%22%2C%22m5%22%3A%227CA0F21E-BA78-4652-B644-56FA67EE9331%22%2C%22c_device%22%3A%22iPhone%208%20Plus%22%2C%22c_h%22%3A2208%2C%22muid%22%3A%220929af4927358426b1a0337bc6b08331%22%2C%22lng%22%3A0%2C%22c_pkgname%22%3A%22com.spriteapp.baisibdjhd%22%2C%22c_os%22%3A%22ios%22%2C%22render_type%22%3A1%2C%22m7%22%3A%225D1802EC-1D7E-6507-69CC-822F713C48DB%22%2C%22conn%22%3A1%2C%22scs%22%3A%220001e73e0b28%22%2C%22c_hl%22%3A%22zh%22%2C%22c_w%22%3A1242%2C%22c_devicetype%22%3A1%2C%22carrier%22%3A0%2C%22c_sdfree%22%3A0%2C%22lat%22%3A0%2C%22c_ori%22%3A0%2C%22c_dpi%22%3A320%2C%22sdkver%22%3A%224.7.8%22%2C%22deep_link_version%22%3A1%2C%22placement_type%22%3A9%2C%22tmpallpt%22%3Atrue%2C%22c_osver%22%3A%2212.1.2%22%7D%7D&count=10&adposcount=1&datatype=2&support_https=1";
     */
    // 启动广告
    NSString *urlStr = @"https://mi.gdt.qq.com/gdt_mview.fcg?posw=640&spsa=1&posid=8060144347834081&ext=%7B%22req%22%3A%7B%22loc_accuracy%22%3A0%2C%22sdk_src%22%3A%22%22%2C%22muidtype%22%3A2%2C%22c_isjailbroken%22%3Afalse%2C%22jsver%22%3A%22%22%2C%22m5%22%3A%227CA0F21E-BA78-4652-B644-56FA67EE9331%22%2C%22c_device%22%3A%22iPhone%208%20Plus%22%2C%22c_h%22%3A2208%2C%22muid%22%3A%220929af4927358426b1a0337bc6b08331%22%2C%22lng%22%3A0%2C%22c_pkgname%22%3A%22com.spriteapp.baisibdjhd%22%2C%22c_os%22%3A%22ios%22%2C%22render_type%22%3A1%2C%22m7%22%3A%225D1802EC-1D7E-6507-69CC-822F713C48DB%22%2C%22conn%22%3A1%2C%22scs%22%3A%220001b2787cc8%22%2C%22c_hl%22%3A%22zh%22%2C%22c_w%22%3A1242%2C%22c_devicetype%22%3A1%2C%22carrier%22%3A0%2C%22c_sdfree%22%3A0%2C%22lat%22%3A0%2C%22c_ori%22%3A0%2C%22c_dpi%22%3A320%2C%22sdkver%22%3A%224.7.8%22%2C%22deep_link_version%22%3A1%2C%22placement_type%22%3A4%2C%22tmpallpt%22%3Atrue%2C%22c_osver%22%3A%2212.1.2%22%7D%7D&posh=960&count=1&datatype=2&support_https=1&adposcount=1";
    
    //3. 发送请求
    //__weak typeof(self) weakSelf;
    [self.manager GET:urlStr parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        NSDictionary *adDict = responseObject[@"data"][@"8060144347834081"][@"list"][0];
        self.startupADItem = [GYADItem mj_objectWithKeyValues:adDict];
        if(completionHandle) {
            completionHandle(self.startupADItem, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) {
            completionHandle(nil, error);
        }
    }];
}

#pragma mark - 获取首页数据
- (void)requestEssenceData:(void(^)(NSArray *essences, NSError * error))completionHandle {
    NSString *usrlStr = @"http://s.budejie.com/public/list-appbar/bsbdjhd-iphone-5.1.0/";
    [self.manager GET:usrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSArray *array = [GYEssenceItem mj_objectArrayWithKeyValuesArray:responseObject[@"menus"][0][@"submenus"]];
        self.essenceItems = array;
        if(completionHandle) {
            completionHandle(array, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) {
            completionHandle(nil, error);
        }
    }];
}

- (void)requestEssenceSubDataWithType:(GYEssenceNetDataType)essenceNetDataType
                          refreshType:(GYRefreshType)refreshType
                           completion:(void(^)(NSArray *topics, NSError * error))completionHandle {
    //NSArray<GYEssenceItem*> *essences = [GYNetworkingManager shareManager].essenceItems;
    NSInteger index = essenceNetDataType;
    if(index >= _essenceItems.count) {
        @throw [NSException exceptionWithName:@"索引值超界" reason:@"获取精华模型数据的索引值超过最大值" userInfo:nil];
    }
    GYEssenceItem *essenceItem = _essenceItems[index];
    NSMutableArray *topicItems = _allTopicItems[index];

    NSString *str = @"";
    if(index < 4) {
        NSString *startID = @"0";
        NSString *endID = @"0";
        if(topicItems.count > 0) {
            GYTopicItem *startItem = [topicItems firstObject];
            GYTopicItem *endItem = [topicItems lastObject];
            if(refreshType == GYRefreshTypePulldown) { // 下拉刷新
                endItem = topicItems[1];
            }
            startID = startItem.ID;
            endID = endItem.ID;
            
        }
        str = [NSString stringWithFormat:@"%@-%@/", startID, endID];
    }
    str = [str stringByAppendingString:@"bsbdjhd-iphone-5.1.0/0-25.json"];
    NSString *usrlStr = [essenceItem.url stringByAppendingString:str];
    [self.manager GET:usrlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSArray *array = [GYTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        if(refreshType == GYRefreshTypePulldown) { // 下拉刷新
            int insetIndex = 0;
            for (GYTopicItem *item in array) {
                [topicItems insertObject:item atIndex:insetIndex];
                insetIndex++;
            }
        } else {
            for (GYTopicItem *item in array) {
                [topicItems addObject:item];
            }
        }
        if(completionHandle) completionHandle(array, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) completionHandle(nil, error);
    }];
}
#pragma mark - 获取社区页数据
- (void)requestPromotionData:(void(^)(NSArray *promotions, NSError * error))completionHandle {// 社区推广
    NSString *urlStr = @"http://s.budejie.com/op2/promotion/bsbdjhd-iphone-5.0.9-appstore/0-100.json";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSArray *array = responseObject[@"result"][@"faxian"][@"1"];
        self.promotions = [GYPromotionItem mj_objectArrayWithKeyValuesArray:array];
        if(completionHandle) completionHandle(self.promotions, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) completionHandle(nil, error);
    }];
}

- (void)requestSubscribeData:(void(^)(NSArray *subscribes, NSError * error))completionHandle {// 订阅数据
    NSString *urlStr = @"http://d.api.budejie.com/forum/subscribe/bsbdjhd-iphone-5.0.9.json";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        self.subscribes = [GYSubscribeItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        if(completionHandle) completionHandle(self.subscribes, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) completionHandle(nil, error);
    }];
}

- (void)requestHotSearchData:(void(^)(NSArray *hotSearches, NSError * error))completionHandle {// 热门搜索
    NSString *urlStr = @"http://d.api.budejie.com/topic/hotsearch/bsbdjhd-iphone-5.0.9/0-20.json";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        self.hotSearches = [GYHotSearchItem mj_objectArrayWithKeyValuesArray:responseObject[@"hot_search"]];
        if(completionHandle) completionHandle(self.hotSearches, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) completionHandle(nil, error);
    }];
}

#pragma mark - 获取关注页数据
- (void)requestFriendRecommendData:(void(^)(NSArray *recommendFriends, NSError * error))completionHandle {
    NSString *urlStr = @"http://d.api.budejie.com/user/friend_recommend/bsbdjhd-iphone-5.0.9/6-last_coord-list/";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        self.recommendFriends = [GYRecommendFriendItem mj_objectArrayWithKeyValuesArray:responseObject[@"hot_list"]];
        if(completionHandle) completionHandle(self.recommendFriends, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) completionHandle(nil, error);
    }];
}

- (void)requestFriendTopicData:(void(^)(NSArray *friendTopics, NSError * error))completionHandle {// 关注帖子
    NSString *urlStr = @"http://d.api.budejie.com/topic/list/jingxuan/attention/bsbdjhd-iphone-5.0.9/0-20.json";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        NSArray *array = [GYTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        for (GYTopicItem *item in array) {
            [self.friendTopics addObject:item];
        }
        if(completionHandle) completionHandle(self.friendTopics, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) completionHandle(nil, error);
    }];
}

#pragma mark - 获取"我的"第三方推荐
- (void)requestMeSquareData:(void(^)(NSMutableArray *squares, NSError * error))completionHandle {
    NSString *urlStr = @"http://s.budejie.com/op/square2/bsbdjhd-iphone-5.1.0/appstore/0-100.json";
    [self.manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary*  _Nullable responseObject) {
        self.squares = [GYSquareItem mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
        if(completionHandle) completionHandle(self.squares, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(completionHandle) completionHandle(nil, error);
    }];
}




@end
