//
//  YbsBaseViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsBaseViewController.h"
#import "UIBarButtonItem+YbsAdd.h"

@interface YbsBaseViewController ()

@end

@implementation YbsBaseViewController

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.appearedNeedRefresh = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kColorHex(@"#F1F1F1");
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self configWindowLevel];
    [self configTitleView];
    [self configLeftBarButtonItem];
    [self configRightBarButtonItem];
}

- (void)configWindowLevel{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.windowLevel = UIWindowLevelNormal;
    });
}

- (void)configTitleView{
    self.titleView = [[YbsNavTitleView alloc]initWithFrame:CGRectMake(0, 0, kYbsNavigationTitleViewMaxWidth, kYbsNavigationTitleViewHeight) style:YbsTitleViewStyleNormal];
    //self.titleView.delegate = self;
    self.navigationItem.titleView = self.titleView;
}

//若不要返回按钮或者想替换成其他按钮可重写此方法
- (void)configLeftBarButtonItem{
//    YbsBarButtonConfiguration *config = [[YbsBarButtonConfiguration alloc]init];
//    config.type = YbsBarButtonTypeBack;
//    config.normalImageName = @"navi_back";
//    self.leftBarButton = [[YbsNavBarButton alloc]initWithConfiguration:config];
//    [self.leftBarButton addTarget:self action:@selector(onLeftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.leftBarButton];
    
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"navigation_back" highIcon:@"navigation_back" target:self action:@selector(onLeftBarButtonClick)];
    
}

- (void)configRightBarButtonItem{
    
}

- (void)onLeftBarButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
