//
//  GYLoginView.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/26.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYLogRegView.h"

@interface GYLogRegView ()
@property (weak, nonatomic) IBOutlet UIButton *loginRegisterBtn;
@property (weak, nonatomic) IBOutlet UIButton *verBtn;
@property (assign, nonatomic) int loginMode;
@end

@implementation GYLogRegView

+ (instancetype)loginView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][0];
}

+ (instancetype)registerView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil][1];
}

- (IBAction)privacyPolicyClick {
    if([_delegate respondsToSelector:@selector(logRegViewOpenPrivacyPolicy:)]) {
        [_delegate logRegViewOpenPrivacyPolicy:self];
    }
}

- (IBAction)loginModeClick:(UIButton *)btn {
    _loginMode = !_loginMode;
    _verBtn.hidden = !_loginMode;
    if(_loginMode) {
        [btn setTitle:@"密码登录>" forState:UIControlStateNormal];
    } else {
        [btn setTitle:@"验证码登录>" forState:UIControlStateNormal];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    //UIImage *image1 = _loginRegisterBtn.currentBackgroundImage;
    //UIImage *image2 = _loginRegisterBtn.currentBackgroundImage;
    UIImage *image1 = [UIImage imageNamed:@"loginBtnBg_55x45_"];
    //UIImage *image2 = [UIImage imageNamed:@"loginBtnBgClick_55x45_"];
    
 
    image1 = [image1 stretchableImageWithLeftCapWidth:image1.size.width * 0.5 topCapHeight:image1.size.height * 0.5];
    //image2 = [image2 stretchableImageWithLeftCapWidth:image2.size.width * 0.5 topCapHeight:image2.size.height * 0.5];
    
    [_loginRegisterBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    //[_loginRegisterBtn setBackgroundImage:image2 forState:UIControlStateHighlighted];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
