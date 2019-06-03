//
//  GYWebViewController.m
//  BuDeJieGY
//
//  Created by 高源 on 2019/6/2.
//  Copyright © 2019 gaoyuan. All rights reserved.
//

#import "GYWebViewController.h"
#import <WebKit/WebKit.h>

@interface GYWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@end

@implementation GYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:_contentView.bounds];
    [_contentView addSubview:webView];
    [webView loadRequest:[NSURLRequest requestWithURL:_url]];
    _webView = webView;
    
    [webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"canGoForward"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"title"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if([keyPath isEqualToString:@"canGoBack"] || [keyPath isEqualToString:@"canGoForward"]) {
        _goBackItem.enabled = _webView.canGoBack;
        _goForwardItem.enabled = _webView.canGoForward;
    }
    
    if([keyPath isEqualToString:@"estimatedProgress"]) {
        _progress.progress = _webView.estimatedProgress;
        _progress.hidden = _progress.progress >= 1;
    }
    
    if([keyPath isEqualToString:@"title"]) {
        self.title = _webView.title;
    }
}

- (IBAction)goBack:(id)sender {
    [_webView goBack];
}

- (IBAction)goForward:(id)sender {
    [_webView goForward];
}

- (IBAction)reloadWebData:(id)sender {
    [_webView reload];
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
