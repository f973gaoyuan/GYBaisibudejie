//
//  GYPrivacyPolicyVC.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/5/26.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYPrivacyPolicyVC.h"
//#import "<#header#>"
#import <WebKit/WebKit.h>
#import "../../Other/Category/UINavigationBar+Alpha.h"

@interface GYPrivacyPolicyVC ()
//@property (weak, nonatomic) webim *<#name#>;
@end

@implementation GYPrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"百思不得姐 | 隐私政策";
    
    //[self.navigationController.navigationBar setBackgroundAlphaValue:1];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.budejie.com/budejie/privacy.html"]]];
    [self.view addSubview:webView];
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
