//
//  YbsTabBarController.m
//  TaskAround
//
//  Created by xinguang hu on 2018/7/2.
//  Copyright © 2018年 xinguang hu. All rights reserved.
//

#import "YbsTabBarController.h"
#import "YbsNavigationController.h"
#import "YbsHomeViewController.h"
#import "YbsMeViewController.h"


@interface YbsTabBarController ()

@end

@implementation YbsTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YbsHomeViewController *homeVC = [[YbsHomeViewController alloc] init];
    YbsMeViewController *mvc = [[YbsMeViewController alloc]init];
    [self addOneChildVc:homeVC title:@"找任务" imageName:@"tab_home_normal" selectedImageName:@"tab_home_selected"];
    [self addOneChildVc:mvc title:@"我的" imageName:@"tab_me_normal" selectedImageName:@"tab_me_selected"];
    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
}

- (void)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    UIImage * image = kImageNamed(imageName);
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.image = image;
    UIImage *selectedImage = kImageNamed(selectedImageName);
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                kColorHex(@"#333333"), NSForegroundColorAttributeName,
                                                [UIFont systemFontOfSize:12.0],
                                                NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [childVc.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                kColorHex(@"#FF2F29")  ,
                                                NSForegroundColorAttributeName,  [UIFont systemFontOfSize:12.0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
    childVc.title = title;
    UINavigationController *nav = [[YbsNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

@end
