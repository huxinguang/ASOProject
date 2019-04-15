//
//  UIViewController+Setting.m
//  YanXian
//
//  Created by yitailong on 16/7/23.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import "UIViewController+Setting.h"
#import <objc/runtime.h>
#import "TTRuntime.h"

@interface UIViewController (SettingPrivate)

@property (nonatomic, strong) UIImageView *loadingImageView;

@end

@implementation UIViewController (Setting)

+ (void)load
{
//    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionBefore
//        usingBlock:^(id<AspectInfo> info){
//            UIViewController *controller = [info instance];
//            NSArray *viewControllers = controller.navigationController.viewControllers;
//            if (viewControllers.count>1) {
////                if (!controller.navigationController.navigationBarHidden) {
//                    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:controller action:@selector(popPrevController:)];
//                    controller.navigationItem.leftBarButtonItem = item;
////                }
//            }
//            
//        }error:NULL];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [TTRuntime exchangeImplementationsWithClass:self fromInstanceMethodSelector:@selector(viewDidLoad) toInstanceMethodSelector:@selector(hookViewDidLoad)];
        
        [TTRuntime exchangeImplementationsWithClass:self fromInstanceMethodSelector:@selector(viewWillAppear:) toInstanceMethodSelector:@selector(hookViewWillAppear:)];
    });
}


- (void)hookViewDidLoad
{
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    if (viewControllers.count>1) {
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popPrevController:)];
//        self.navigationItem.leftBarButtonItem = item;
//    }

    [self hookViewDidLoad];
}

- (void)hookViewWillAppear:(BOOL)animated
{

    [self hookViewWillAppear:animated];
}

- (void)popPrevController:(UIBarButtonItem *)item
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark -- HUD methods

- (void)showMessage:(NSString *)message
{
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = nil;
    self.hud.detailsLabel.text = message;
    [self.hud showAnimated:YES];
}

- (void)showHudWithMessage:(NSString *)message
{
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.label.text = nil;
    self.hud.detailsLabel.text = message;
    [self.hud showAnimated:YES];
}

- (void)showMessageDelayHide:(NSString *)message
{
    [self showMessage:message hideDelay:1];
}

- (void)showMessage:(NSString *)message hideDelay:(NSTimeInterval)delay
{
    [self.hud showAnimated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = message;
    self.hud.label.numberOfLines = 0;
    self.hud.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.hud.margin = 12.5;
    self.hud.opaque = NO;
    
//    self.hud.detailsLabel.text = message;
    [self.hud hideAnimated:YES afterDelay:delay];
}

- (void)showMessage:(NSString *)message hideDelay:(NSTimeInterval)delay complete:(void(^)(void))complete
{
    [self.hud showAnimated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.label.text = message;
    self.hud.label.numberOfLines = 0;
    self.hud.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.hud.margin = 12.5;

    [self.hud hideAnimated:YES afterDelay:delay];
    self.hud.completionBlock = complete;
}


- (void)showMessageToWindow:(NSString *)message hideDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:[UIScreen mainScreen].bounds];
    hud.detailsLabel.font = [UIFont systemFontOfSize:17];
    hud.contentColor = [UIColor whiteColor];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:hud];
    [hud showAnimated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.numberOfLines = 0;
    hud.label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    hud.margin = 12.5;
    [hud hideAnimated:YES afterDelay:delay];
 
}


- (void)hideHudWithMessage:(NSString *)message isSuccess:(BOOL)isSuccess
{
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.label.text = nil;
    self.hud.detailsLabel.text = message;
    self.hud.minShowTime = 2;
    NSString *icon = nil;
    if (isSuccess) {
        icon = @"common_def_suess";
    } else {
        icon = @"hudError.png";
    }
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    [self.hud hideAnimated:YES afterDelay:2];
}

- (void)hideHUD
{
    [self.hud hideAnimated:YES];
}

- (void)hideHUDDelay:(NSTimeInterval)delay
{
    [self.hud hideAnimated:YES afterDelay:delay];
}

- (void)showLoading
{
    [self showLoadingUserInteractionEnabled:YES];
}

- (void)showLoadingUserInteractionEnabled:(BOOL )enabled;
{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = enabled;
    self.loadingImageView.hidden = NO;
    [self.view bringSubviewToFront:self.loadingImageView];
    [self.loadingImageView startAnimating];
}

- (void)hideLoading
{
    [UIApplication sharedApplication].keyWindow.userInteractionEnabled = YES;
    self.loadingImageView.hidden = YES;
    [self.loadingImageView stopAnimating];
}

#pragma mark - setter & getter

- (UIViewController *)getSubControllerClass:(NSString *)classController
{
    NSArray *listOfChild = self.childViewControllers;
    UIViewController *controller = nil;
    for (UIViewController *tempControlelr in listOfChild) {
        if ([tempControlelr isKindOfClass:NSClassFromString(classController)]) {
            controller = tempControlelr;
        }
    }
    return controller;
}

- (void)setLoadingImageView:(UIImageView *)loadingImageView
{
    objc_setAssociatedObject(self, @selector(loadingImageView), loadingImageView, OBJC_ASSOCIATION_RETAIN);
}

- (UIImageView *)loadingImageView
{
    UIImageView *loadImageView = objc_getAssociatedObject(self, @selector(loadingImageView));
    if (!loadImageView) {
        loadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 68, 68)];
        loadImageView.hidden = YES;
        loadImageView.image = [UIImage imageNamed:@"医_00000.png"];
        NSMutableArray *loadingImages = [@[] mutableCopy];
        for (NSUInteger i = 1; i<=5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"医_0000%zd", i]];
            [loadingImages addObject:image];
        }
        loadImageView.animationImages = loadingImages;
        loadImageView.animationDuration = 0.3;
        [self.view addSubview:loadImageView];
        [loadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(68));
            make.centerY.equalTo(self.view.mas_centerY);
            make.centerX.equalTo(self.view.mas_centerX);
        }];
        objc_setAssociatedObject(self, @selector(loadingImageView), loadImageView, OBJC_ASSOCIATION_RETAIN);
    }
    
    return loadImageView;
}

- (void)setHud:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(self, @selector(hud), hud, OBJC_ASSOCIATION_RETAIN);
}

- (MBProgressHUD *)hud
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, @selector(hud));
    if (!hud) {

        hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.detailsLabel.font = [UIFont systemFontOfSize:17];
        hud.contentColor = [UIColor whiteColor];
        hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55];
        
//        hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.55];
        
//        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [self.view addSubview:hud];
        
        objc_setAssociatedObject(self, @selector(hud), hud, OBJC_ASSOCIATION_RETAIN);
    }
    
    [self.view bringSubviewToFront:hud];
    return hud;
}

- (BOOL)hidesBottomBarWhenPushed
{
    UIViewController *controller = self.navigationController.viewControllers.firstObject;
    if (controller == self) {
        return NO;
    }
    return YES;
}
@end
