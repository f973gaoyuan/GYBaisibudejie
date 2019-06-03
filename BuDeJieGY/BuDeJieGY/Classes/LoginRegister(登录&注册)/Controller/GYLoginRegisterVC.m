//
//  GYLoginRegisterVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/26.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYLoginRegisterVC.h"
//#import "../../Other/Category/UIImage+Render.h"
#import "GYPrivacyPolicyVC.h"
#import "../View/GYLogRegView.h"

#import "../../Other/Category/UINavigationBar+Alpha.h"


@interface GYLoginRegisterVC () <GYLogRegViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) GYLogRegView *loginV;
@property (weak, nonatomic) GYLogRegView *registerV;
@property (weak, nonatomic) UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingCons;

@end

@implementation GYLoginRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //login_close_icon_16x16_
    self.navigationItem.title = @"登录";
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_close_icon_21x21_"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismissVC)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateSelected];
    //[btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateSelected];
    //[btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];

    [btn addTarget:self action:@selector(loginRegisterSwitch) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn = btn;
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init]
//                                                  forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundAlphaValue:0];
    //*******************************
    GYLogRegView *loginV = [GYLogRegView loginView];
    [self.middleView addSubview:loginV];
    self.loginV = loginV;

    GYLogRegView *registerV = [GYLogRegView registerView];
    [self.middleView addSubview:registerV];
    registerV.delegate = self;
    self.registerV = registerV;
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:^{
     }];
}

- (void)loginRegisterSwitch {
    _rightBtn.selected = !_rightBtn.selected;
    _leadingCons.constant = (_leadingCons.constant == 0) ? -GYScreenW : 0;
    
    if(_rightBtn.selected) {
        self.navigationItem.title = @"注册";
    } else {
        self.navigationItem.title = @"登录";
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.loginV.frame = self.middleView.bounds;
    self.loginV.width = GYScreenW;
    
    self.registerV.frame = self.middleView.bounds;
    self.registerV.x  = GYScreenW;
    self.registerV.width = GYScreenW;
}
#pragma mark - GYLogRegViewDelegate
- (void)logRegViewOpenPrivacyPolicy:(GYLogRegView*)logRegV {
    GYPrivacyPolicyVC *vc = [[GYPrivacyPolicyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
