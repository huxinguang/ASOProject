//
//  UIViewController+Setting.h
//  YanXian
//
//  Created by yitailong on 16/7/23.
//  Copyright © 2016年 yitailong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface UIViewController (Setting)

@property (nonatomic, strong, readonly) MBProgressHUD *hud;

- (void)showMessage:(NSString *)message;
- (void)showHudWithMessage:(NSString *)message;
- (void)showMessageDelayHide:(NSString *)message;
- (void)showMessage:(NSString *)message hideDelay:(NSTimeInterval)delay;
- (void)showMessage:(NSString *)message hideDelay:(NSTimeInterval)delay complete:(void(^)(void))complete;
- (void)showMessageToWindow:(NSString *)message hideDelay:(NSTimeInterval)delay;

- (void)hideHudWithMessage:(NSString *)message isSuccess:(BOOL)isSuccess;
- (void)hideHUD;
- (void)hideHUDDelay:(NSTimeInterval)delay;

- (void)showLogo:(NSString *)logo Title:(NSString *)title subTitle:(NSString *)subTitle;
- (void)showLogo:(NSString *)logo Title:(NSString *)title subTitle:(NSString *)subTitle didTappedBlock:(void(^)())tappedBlock;
- (void)showTransferListEmptyInfo;
- (void)showAuthorizingIdentityInfo;
- (void)showUnauthorizedIdentityInfoDidTappedBlock:(void(^)())tappedBlock;
- (void)showIdentityFailureInfoDidTappedBlock:(void(^)())tappedBlock;
- (void)showNoDepartmentDoctorInfo;
- (void)showNoCooOrgnizationInfo;
- (void)showNoDepartmentsInfo;
- (void)hideAllInfo;

- (void)showLoading;
- (void)showLoadingUserInteractionEnabled:(BOOL )enabled;
- (void)hideLoading;

@end
