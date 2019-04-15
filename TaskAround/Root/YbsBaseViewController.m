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

@property (nonatomic, strong) YbsPlaceholderView *placeholderView;

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
    if (self.isPlaceholderShown) {
        for (UIView *item in self.placeholderView.subviews) {
            item.alpha = 0;
        }
        [UIView animateWithDuration:0.35 animations:^{
            for (UIView *item in self.placeholderView.subviews) {
                item.alpha = 1;
            }
        }];
    }
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

- (void)showPlaceholderViewWithType:(YbsPlaceholderType)type imgName:(NSString *)name btnTitle:(NSString *)title message:(NSString *)msg  clickBlock:(PlaceholderClickBlock)block{
    self.placeholderView.imageName = name;
    self.placeholderView.btnTitle = title;
    self.placeholderView.msg = msg;
    self.placeholderView.clickBlock = block;
    self.placeholderView.type = type;
    [self.view layoutIfNeeded];
    [self.view bringSubviewToFront:self.placeholderView];
    
}

- (void)dismissPlaceholderView{
    if ([self.view.subviews containsObject:_placeholderView]) {
        [_placeholderView removeFromSuperview];
        _placeholderView = nil;
    }
}

#pragma mark - Getter

- (YbsPlaceholderView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView = [YbsPlaceholderView new];
        [self.view addSubview:_placeholderView];
        [_placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _placeholderView;
}

- (BOOL)isPlaceholderShown{
    if (!_placeholderView) {
        return NO;
    }else{
        return [self.view.subviews containsObject:_placeholderView];
    }
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
