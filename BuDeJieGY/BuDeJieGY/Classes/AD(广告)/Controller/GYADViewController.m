//
//  GYADViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/16.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYADViewController.h"
//#import <SDWebImage/SDWebImageManager.h>
#import "../../Main(主要)/Controller/GYTabBarController.h"




#import "../Model/GYADItem.h"
#import "../../Other/Category/NSObject+Model.h"
#import "../../Other/Category/NSDictionary+Property.h"
#import "../../Other/Category/NSObject+Model.h"

/*
 组件化开发
 cocoapods: 管理第三方框架，继承第三方框架
 cocoapods使用步骤: 命令行
 1. 创建Podfile文件(描述当前工程需要那些框架): pod init
 2. 打开Podfile进行描述: open
 3. 查找名称: pod search AFN
 4. pod install
 
 使用cocoapods好处
 1. 更新框架
 2. 自动引入所依赖的其它框架
 3. 组件(小功能框架)化开发
 4. 优化代码内存容量
 例如: IJKPlayer: 直播框架 100M
 */



#define Retina_HD_4_7   (GYScreenH == 667)
#define Retina_HD_5_5   (GYScreenH == 736)
#define iPhone_X_Xs     (GYScreenH == 812)
#define iPhone_XR_XsMax (GYScreenH == 896)
/*
#define iPhoneXsMax     ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone Xs Max"])
#define iPhoneXʀ        ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone Xʀ"])
#define iPhoneXs        ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone Xs"])
#define iPhoneX         ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone X"])

#define iPhone6         ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone 6"])
#define iPhone6P        ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone 6 Plus"])
#define iPhone6s        ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone 6s"])
#define iPhone6sP        ([[[UIDevice currentDevice] name] isEqualToString:@"iPhone 6s Plus"])
*/
/*
 占位视图：当一个界面层次结构确定，但其中一个结构尺寸不确定(层次结构多)
 */

@interface GYADViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *adContentView;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *launchHeight;
@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) GYADItem *item;
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation GYADViewController
- (IBAction)jump:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    GYTabBarController *tabBarVC = [[GYTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
}

- (AFHTTPSessionManager *)manager {
    if(_manager == nil) {
        _manager = [AFHTTPSessionManager gy_manager];
        // 客户端是否信任非法证书
        _manager.securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        [_manager.securityPolicy setValidatesDomainName:NO];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _jumpBtn.layer.cornerRadius = 15;
    
    
    // 设置启动图片
    [self setupLaunchImageView];
    
    // 展示广告数据 =》从服务器取 =》 接口文档 =》 AFN =》 cocoapods
    [self loadADData];
//    GYLog(@"GYScreen: %.0f x %.0f", GYScreenW, GYScreenH);
//    NSString *name = [[UIDevice currentDevice] name];
//    GYLog(@"name: %@", name);
//    [[[UIDevice currentDevice] name] isEqualToString:@"iPhone Xs Max"];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        static int count = 3;
        if(count == -1) {
            [self jump:nil];
        }
        NSString *str = [NSString stringWithFormat:@"跳过 (%d)", count];
        [self.jumpBtn setTitle:str forState:UIControlStateNormal];
        count--;
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}
// 请求数据 =》 接口文档 =》 AFN发送请求 =》 解析数据 =》 写成plisti=》 设计模型 =》 字典转模型 =》 直接把模型展示到界面
- (void)loadADData {
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
        
        GYADItem *item = [GYADItem mj_objectWithKeyValues:adDict];
        self.item = item;
        CGFloat h = 0;
        if(item.pic_width > 0) {
            h = item.pic_height * GYScreenW / item.pic_width;
        }
        self.adImageView.frame = CGRectMake(0, 0, GYScreenW, h);
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:item.img]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAD)];
        [self.adContentView addGestureRecognizer:tap];
        
/*
        UIImageView *imageView = [[UIImageView alloc] init];
        //imageView.contentMode = UIViewContentModeScaleAspectFill;
        //imageView.clipsToBounds = YES;
        CGFloat h = item.pic_height * GYScreenW / item.pic_width;
        //CGFloat hMax = GYScreenH * 0.8;
        //if(h > hMax) h = hMax;
        imageView.frame = CGRectMake(0, 0, GYScreenW, h);
        [self.adContentView addSubview:imageView];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.img]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAD)];
        
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
*/
        //[adDict createProperyCode:adDict];
        //[adDict createProperyCode:dict];
        //GYADItem *item = [GYADItem modelWithDictionary:adDict];
        
        //GYLog(@"------------%@", adDict);
        
        //[responseObject writeToFile:@"/Users/gaoyuan/Desktop/GIT/f973gaoyuan/ad.plist" atomically:YES];
        //NSString *str = [GYTool convertToJsonData:responseObject];
        // 不知为什么非要这样才能存储成功
        //[[GYTool dictionaryWithJsonString:str] writeToFile:@"/Users/gaoyuan/Desktop/GIT/f973gaoyuan/ad.plist" atomically:YES];
        
        //GYLog(@"------------%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // GYLog(@"------------%@", error);
    }];
}
#pragma mark - 点击广告图片调用网页
- (void)tapAD {
    GYLog(@"进入广告界面");
    NSString *urlStr = _item.rl;
    //urlStr = [urlStr stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    }
}

- (void)setupLaunchImageView {
    self.launchHeight.constant = GYScreenW * 400.0 / 1242.0;
    // iPhone 6/6s/7        750 x 1334
    // iPhone 6/6s/7 Plus   1080 x 1920
    // Retina HD 4.7        750 x 1334     @2x  667
    // Retina HD 5.5        1242 x 2208    @3x  736
    // iPhone X / Xs        1125 x 2436    @3x  812
    // iPhone XR            828 x 1792     @2x  896
    // iPhone Xs Max        1242 x 2688    @3x  896
    NSString *imgName = nil;
    if(Retina_HD_4_7) {             // 750 x 1334     @2x  667
        imgName = @"Retina HD 4.7 -D";
    } else if(Retina_HD_5_5) {      // 1242 x 2208    @3x  736
        imgName = @"Retina HD 5.5 -D";
    } else if(iPhone_X_Xs) {        // 1125 x 2436    @3x  812
        imgName = @"iPhone X -D";
    } else if(iPhone_XR_XsMax) {
        NSString *device = [[UIDevice currentDevice] name];
        if([device isEqualToString:@"iPhone Xʀ -D"]) {             // 828 x 1792     @2x  896
            imgName = @"iPhone XR";
        } else if([device isEqualToString:@"iPhone Xs Max -D"]) {  // 1242 x 2688    @3x  896
            imgName = @"iPhone Xs Max";
        }
    }
    
    UIImage *image = [UIImage imageNamed:imgName];
    
    _launchImageView.image = image;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
