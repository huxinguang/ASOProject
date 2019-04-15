//
//  YbsBaseViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YbsNavBarButton.h"
#import "YbsNavTitleView.h"
#import "YbsPlaceholderView.h"
#import "UIViewController+YbsUtil.h"



NS_ASSUME_NONNULL_BEGIN

@interface YbsBaseViewController : UIViewController

@property (nonatomic, strong) YbsNavTitleView *titleView;
@property (nonatomic, strong) YbsNavBarButton *leftBarButton;
@property (nonatomic, strong) YbsNavBarButton *rightBarButton;
@property (nonatomic, getter=isPlaceholderShown) BOOL placeholderShown;

@property (nonatomic, assign) BOOL isStatusBarHidden;

- (void)configTitleView;

- (void)configLeftBarButtonItem;

- (void)configRightBarButtonItem;

- (void)onLeftBarButtonClick;

- (void)showPlaceholderViewWithType:(YbsPlaceholderType)type imgName:(NSString *)name btnTitle:(NSString *)title message:(NSString *)msg  clickBlock:(PlaceholderClickBlock)block;

- (void)dismissPlaceholderView;



@end

NS_ASSUME_NONNULL_END
