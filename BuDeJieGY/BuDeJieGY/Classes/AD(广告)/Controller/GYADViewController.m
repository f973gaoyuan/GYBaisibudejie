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
#import "../../Utils(业务类)/NetWorking/GYNetworkingManager.h"


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
@property (weak, nonatomic) GYADItem *item;
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation GYADViewController
- (IBAction)jump:(id)sender {
    [self.timer invalidate];
    self.timer = nil;
    GYTabBarController *tabBarVC = [[GYTabBarController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _jumpBtn.layer.cornerRadius = 15;
    
    
    // 设置启动图片
    [self setupLaunchImageView];
    
    GYNetworkingManager *manager = [GYNetworkingManager shareManager];
    // 展示广告数据 =》从服务器取 =》 接口文档 =》 AFN =》 cocoapods
    //[manager requestEssenceData:nil];
    [manager requestEssenceData:^(NSArray *essences, NSError *error) {
        //[manager cancelAllRequest];
        [manager requestStartupADData:^(GYADItem *item, NSError *error) {
            if(error) {
                [self jump:nil];
                return;
            }
            self.item = item;
            CGFloat h = 0;
            if(item.pic_width > 0) {
                h = item.pic_height * GYScreenW / item.pic_width;
            }
            self.adImageView.frame = CGRectMake(0, 0, GYScreenW, h);
            [self.adImageView sd_setImageWithURL:[NSURL URLWithString:item.img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
             
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAD)];
                [self.adContentView addGestureRecognizer:tap];
                
                //[manager cancelAllRequest];
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    static int count = 3;
                    if(count == -1) {
                        [self jump:nil];
                    }
                    NSString *str = [NSString stringWithFormat:@"跳过 (%d)", count];
                    [self.jumpBtn setTitle:str forState:UIControlStateNormal];
                    count--;
                }];
            }];
       }];
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    //[_manager.tasks makeObjectsPerformSelector:@selector(cancel)];
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
