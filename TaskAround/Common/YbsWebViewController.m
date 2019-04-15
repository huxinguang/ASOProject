//
//  YbsWebViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/20.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsWebViewController.h"
#import <WebKit/WebKit.h>

@interface YbsWebViewController ()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation YbsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:self.pageTitle];
    
    self.webView = [[WKWebView alloc]init];
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [MBProgressHUD showLoadingInView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.pageUrl]]];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [MBProgressHUD hideHUD];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [MBProgressHUD hideHUD];
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
