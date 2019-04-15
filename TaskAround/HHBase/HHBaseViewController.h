//
//  HHBaseViewController.h
//  BaseTabBar
//
//  Created by 豫风 on 2017/6/23.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+HHLayout.h"
#import "UIViewController+HHConstruct.h"
#import "KDCommonMacro.h"


#ifndef LeftImage
#define LeftImage @"navBack"
#endif

#ifndef RightImage
#define RightImage @""
#endif


NS_ASSUME_NONNULL_BEGIN

@interface HHBaseViewController : UIViewController <DoubleClickProtocol>

@property (nonatomic, assign) SEL       leftSelector;
@property (nonatomic, assign) SEL       rightSelector;
@property (nonatomic, assign) BOOL      isShowNaviBar;
@property (nonatomic, assign) BOOL      isShowLeftBtn;
@property (nonatomic, assign) BOOL      isShowRightBtn;
@property (nonatomic, copy)   NSString  *navTitle;
@property (nonatomic, copy)   NSString  *leftImage;
@property (nonatomic, copy)   NSString  *rightImage;
@property (nonatomic, copy)   NSString  *navImageName;
@property (nonatomic, strong) UIView    *bgView;
@property (nonatomic, strong) UIView    *navView;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIButton  *leftButton;
@property (nonatomic, strong) UIButton  *rightButton;


/**
 动态显示navBar

 @param isShow 是否显示
 @param animate 是否需要动画
 */
- (void)showNavBar:(BOOL)isShow animation:(BOOL)animate;

/**
 强制设置转屏

 @param orientation 转屏方向
 */
- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation;



@end
NS_ASSUME_NONNULL_END
