//
//  YbsHomeViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsHomeViewController.h"
#import "YbsLocationManager.h"
#import "YbsNavigationController.h"


@interface YbsHomeViewController ()

@end

@implementation YbsHomeViewController

- (void)configLeftBarButtonItem{
    
}

- (void)configTitleView{
    self.titleView = [[YbsNavTitleView alloc]initWithFrame:CGRectMake(0, 0, kYbsNavigationTitleViewMaxWidth, kYbsNavigationTitleViewHeight) style:YbsTitleViewStyleSegement];
    @weakify(self);
    self.titleView.block = ^(NSInteger selectedIndex) {
        @strongify(self);
        if (selectedIndex == 0) {
            [self transitionFromViewController:self.lvc toViewController:self.mvc duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                self.currentVC = self.mvc;
            }];
        }else{
            if (![self.childViewControllers containsObject:self.lvc]) {
                [self addChildViewController:self.lvc];
                [self.view addSubview:self.lvc.view];
                self.lvc.view.frame = CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight-kAppStatusBarAndNavigationBarHeight-kAppTabbarHeight);
            }
        
            [self transitionFromViewController:self.mvc toViewController:self.lvc duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
                
            } completion:^(BOOL finished) {
                self.currentVC = self.lvc;
            }];
        }
    };
    self.navigationItem.titleView = self.titleView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.mvc];
    [self.view addSubview:self.mvc.view];
    
}

- (YbsTaskListViewController *)lvc{
    if (!_lvc) {
        _lvc = [YbsTaskListViewController new];
    }
    return _lvc;
}

- (YbsTaskMapViewController *)mvc{
    if (!_mvc) {
        _mvc = [YbsTaskMapViewController new];
    }
    return _mvc;
}

- (void)setCurrentVC:(UIViewController *)currentVC{
    if (currentVC == self.lvc) {
        [self.view bringSubviewToFront:self.lvc.view];
    }else{
        [self.view bringSubviewToFront:self.mvc.view];
    }
    _currentVC = currentVC;
}



@end
