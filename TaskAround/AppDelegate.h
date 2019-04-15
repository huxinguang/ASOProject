//
//  AppDelegate.h
//  TaskAround
//
//  Created by xinguang hu on 2018/7/2.
//  Copyright © 2018年 xinguang hu. All rights reserved.
//

#import <UIKit/UIKit.h>

// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/// iOS 10 及以上环境，需要添加 UNUserNotificationCenterDelegate 协议，才能使用 UserNotifications.framework 的回调

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)isNeedUpdateNewVersion;


@end

