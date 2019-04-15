//
//  HHBaseViewController.m
//  BaseTabBar
//
//  Created by 豫风 on 2017/6/23.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "HHBaseViewController.h"
#import "UIView+HHAddSubviews.h"
#import "UIView+HHLayout.h"
#import "UIImage+YbsUtil.h"

#ifndef NavHeight
#define NavHeight 88
#endif

@interface HHBaseViewController ()

@property (nonatomic, strong) NSLayoutConstraint *navTopConstraint;
@property (nonatomic, assign) CGFloat navTopDistance;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HHBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseViewInfo];
    [self setupLayoutSubViews];
    [self configBaseNavViewInfo];
}
- (void)configBaseViewInfo
{
    self.navTopDistance = 0.0f;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, NavHeight)];
    [self.view addSubview:self.navView];
    self.navView.backgroundColor = kColorHex(kYbsNavigationBarColor);
//    [self.navView hh_addImageView:^(UIImageView *imageView) {
//        self.imageView = imageView;
//        imageView.image = self.navImageName?[UIImage stretchImageNamed:self.navImageName]:[UIImage stretchImageNamed:@"navbg"];
//        imageView.around_();
//    }];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kAppScreenWidth, self.view.height-64)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.view insertSubview:_bgView atIndex:0];
}
- (void)configBaseNavViewInfo
{
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navView addSubview:self.leftButton];
    self.leftButton.topLeft_(CGRectMake(0, 20+self.navTopDistance, 44, 44));
    [self.leftButton setImage:[UIImage imageNamed:LeftImage] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.navView addSubview:self.rightButton];
    self.rightButton.topRight_(CGRectMake(0, 20+self.navTopDistance, 44, 44));
    [self.rightButton setImage:[UIImage imageNamed:RightImage] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.navView addSubview:self.titleLabel];
    self.titleLabel.centY.centX.equalTo(self.navView).offset(5+self.navTopDistance/2).on_();
}
- (void)setupLayoutSubViews
{
    self.navView.translatesAutoresizingMaskIntoConstraints = NO;
    _navTopConstraint = [NSLayoutConstraint constraintWithItem:self.navView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *navHeight = [NSLayoutConstraint constraintWithItem:self.navView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:NavHeight+self.navTopDistance];
    [self.view addConstraint:_navTopConstraint];
    [self.navView addConstraint:navHeight];
    NSDictionary *navDict = NSDictionaryOfVariableBindings(_navView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_navView]|" options:0 metrics:nil views:navDict]];
    
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bgDict = NSDictionaryOfVariableBindings(_bgView,_navView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_navView]-0-[_bgView]|" options:0 metrics:nil views:bgDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bgView]|" options:0 metrics:nil views:bgDict]];
}

- (void)leftButtonClick:(UIButton *)sender
{
    if (_leftSelector && [self respondsToSelector:_leftSelector]) {
        
        [self performSelectorOnMainThread:_leftSelector withObject:self waitUntilDone:NO];
    }else
    {
        [self customPopViewController];
    }
}
- (void)rightButtonClick:(UIButton *)sender
{
    if (_rightSelector && [self respondsToSelector:_rightSelector]) {
        
        [self performSelectorOnMainThread:_rightSelector withObject:self waitUntilDone:NO];
    }
}
- (void)doubleClickActionNeedToDo{}//need to overWrite

- (void)setNavImageName:(NSString *)navImageName
{
    self.imageView.image = [UIImage imageNamed:navImageName];
}
- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    self.titleLabel.text = navTitle;
    [self.titleLabel sizeToFit];
}
- (void)setLeftImage:(NSString *)leftImage
{
    _leftImage = leftImage;
    [self.leftButton setImage:[UIImage imageNamed:_leftImage] forState:UIControlStateNormal];
}
- (void)setRightImage:(NSString *)rightImage
{
    _rightImage = rightImage;
    [self.rightButton setImage:[UIImage imageNamed:_rightImage] forState:UIControlStateNormal];
}
- (void)setIsShowNaviBar:(BOOL)isShowNaviBar
{
    _isShowNaviBar = isShowNaviBar;
    [self showNavBar:_isShowNaviBar animation:NO];
}
- (void)setIsShowLeftBtn:(BOOL)isShowLeftBtn
{
    _isShowLeftBtn = isShowLeftBtn;
    self.leftButton.hidden = !isShowLeftBtn;
}
- (void)setIsShowRightBtn:(BOOL)isShowRightBtn
{
    _isShowRightBtn = isShowRightBtn;
    self.rightButton.hidden = !_isShowRightBtn;
}
- (void)showNavBar:(BOOL)isShow animation:(BOOL)animate
{
    if (animate) {
        
        if (isShow) {
            
            self.navTopConstraint.constant = 0;
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.view layoutIfNeeded];
            }];
            
        }else
        {
            self.navTopConstraint.constant = - NavHeight;
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.view layoutIfNeeded];
            }];
        }
    }else
    {
        if (isShow) {
            
            self.navTopConstraint.constant = 0;
        }else
        {
            self.navTopConstraint.constant = - NavHeight;
        }
    }
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector  = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&orientation atIndex:2];
        [invocation invoke];
    }
}
- (void)customPopViewController
{
    if(self.navigationController.childViewControllers.count>1)
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


@end
