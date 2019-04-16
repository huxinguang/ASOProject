//
//  AppDelegate.m
//  TaskAround
//
//  Created by xinguang hu on 2018/7/2.
//  Copyright © 2018年 xinguang hu. All rights reserved.
//

#import "AppDelegate.h"
#import "YbsTabBarController.h"
#import "YbsNavigationController.h"
#import "UICKeyChainStore.h"
#import "YbsWelcomeViewController.h"
#import "YbsLoginViewController.h"
#import <Bugly/Bugly.h>
#import "YbsMessageViewController.h"
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import <UMAnalytics/MobClick.h>

//#import <AdSupport/AdSupport.h>

typedef NS_ENUM(NSInteger, YbsAppPushStatus) {
    YbsAppPushStatusOpen, //用户开启了消息通知
    YbsAppPushStatusClose,//用户关闭了消息通知
    YbsAppPushStatusNotDetermined //用户首次打开，未决定是否开启通知
};

typedef void(^PushCheckHandler)(YbsAppPushStatus);


@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    sleep(1.5);
    
    [self checkIfOpenPush:^(YbsAppPushStatus status) {
        
    }];
    
    [self configBugly];
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    
#ifdef DEBUG
    [UMConfigure setLogEnabled:YES];
#else
    [UMConfigure setLogEnabled:NO];
#endif
    
    [UMConfigure initWithAppkey:kUMPushAppkey channel:@"App Store"];
    
    [self configUApp];
    [self configUPush:launchOptions];
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    if (!kUserDefaultGet(kYbsIsFirstLaunchKey)) {
//        kUserDefaultSet(kYbsIsFirstLaunchValue, kYbsIsFirstLaunchKey);
//        @weakify(self);
//        YbsWelcomeViewController *wvc = [[YbsWelcomeViewController alloc]initWithBlock:^{
//            @strongify(self);
//            [self startJourney];
//        }];
//        self.window.rootViewController = wvc;
//    }else{
//        [self startJourney];
//    }
    
    [self startJourney];
    [self setUpKeyboard];
    [self.window makeKeyAndVisible];
    [self mjRefreshIPhoneX];
    [self isNeedUpdateNewVersion];
    
    
//    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    NSLog(@"###############%@",idfa);
    
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    
    NSString *jsonStr = @"";
    if (userInfo == nil) {//说明用户是直接点击APP进入的
        jsonStr = @"userInfo为空";
    }else{//说明用户是点击通知栏进入的
        jsonStr = [userInfo jsonStringEncoded];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"提示"                                                                               message: jsonStr preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    
    [self.window.rootViewController presentViewController: alertController animated: YES completion: nil];

    return YES;
}

- (void)configBugly{
    [Bugly startWithAppId:kBuglyAppID];
}


- (void)configUApp{
    [MobClick setScenarioType:E_UM_NORMAL];//支持普通场景
}




/*
 收到通知时，在不同的状态在点击通知栏的通知时所调用的方法不同。未启动时，点击通知的回调方法是：
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 
 而对应的通知内容则为
 
 NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
 
 当pushNotificationKey为nil时，说明用户是直接点击APP进入的，如果点击的是通知栏，那么即为对应的通知内容。
 */

- (void)configUPush:(NSDictionary *)launchOptions{
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
}


- (void)jumpToMsgVc{
    YbsMessageViewController *vc = [[YbsMessageViewController alloc]init];
    [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES
     ];
}


- (void)setUpKeyboard{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

//- (void) setupCOSXMLShareService {
//    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
//    configuration.appID = kQCloudAppID;
//    configuration.signatureProvider = self;
//    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
//    endpoint.regionName = kQCloudRegion;
//    configuration.endpoint = endpoint;
//
//    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
//    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
//}


#pragma mark - QCloudSignatureProvider

//- (void) signatureWithFields:(QCloudSignatureFields*)fileds
//                     request:(QCloudBizHTTPRequest*)request
//                  urlRequest:(NSMutableURLRequest*)urlRequst
//                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
//{
//    QCloudCredential* credential = [QCloudCredential new];
//    credential.secretID = kQCloudSecretID;
//    credential.secretKey = kQCloudSecretKey;
//    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
//    QCloudSignature* signature =  [creator signatureForData:urlRequst];
//    continueBlock(signature, nil);
//}


- (void)startJourney{
    
    if (kUserDefaultGet(kYbsUserInfoDicKey)) {
        YbsTabBarController *tabController = [[YbsTabBarController alloc] init];
        self.window.rootViewController = tabController;
    }else{
        YbsLoginViewController *loginVC = [[YbsLoginViewController alloc]init];;
        @weakify(self);
        loginVC.successBlock = ^ {
            @strongify(self);
            YbsTabBarController *tabController = [[YbsTabBarController alloc] init];
            self.window.rootViewController = tabController;
        };
        loginVC.visitorBlock = ^{
            @strongify(self);
            YbsTabBarController *tabController = [[YbsTabBarController alloc] init];
            self.window.rootViewController = tabController;
        };
        
        UINavigationController *nav = [[YbsNavigationController alloc] initWithRootViewController:loginVC];
        
        self.window.rootViewController = nav;
    }
    
}


- (void)mjRefreshIPhoneX{
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

- (NSString *)getUniqueIdentifier{
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.ybs.taskaround-uuid"];
    NSString *uuid = [keychain stringForKey:kYbsUUIDKeychainKey];
    if (uuid) {
        
    }else{
        NSString *timeString = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        NSString *randomString = [NSString randomStringWithLength:10];
        uuid = [NSString stringWithFormat:@"%@%@",timeString,randomString];
        [keychain setString:uuid forKey:kYbsUUIDKeychainKey];
    }
    return uuid;
}

- (void)isNeedUpdateNewVersion
{
    
}

- (void)checkIfOpenPush:(PushCheckHandler)completionHandler{
    if ([[[UIDevice currentDevice] systemVersion]intValue] < 8) {// system <iOS8
        UIRemoteNotificationType setting = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (setting == 0) {
            completionHandler(YbsAppPushStatusClose);
        }else
        {
            completionHandler(YbsAppPushStatusOpen);
        }
    }else if ([[[UIDevice currentDevice] systemVersion]intValue] >= 10){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if ((((int)settings.alertSetting == 0)&& ((int)settings.badgeSetting == 0) && ((int)settings.soundSetting == 0))){
                completionHandler(YbsAppPushStatusNotDetermined);
            }
            else if ((((int)settings.alertSetting == 1)&& ((int)settings.badgeSetting == 1) && ((int)settings.soundSetting == 1))) {
                completionHandler(YbsAppPushStatusClose);
            }else
            {
                completionHandler(YbsAppPushStatusOpen);
            }
            
        }];
    }else{
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        if (types == 0) {
            completionHandler(YbsAppPushStatusClose);
        }else
        {
            completionHandler(YbsAppPushStatusOpen);
        }
        
    }
    
}


/*
 开发环境下：
 在 didRegisterForRemoteNotificationsWithDeviceToken 中添加如下语句,可在控制台获取一个长度为64的测试设备的DeviceToken串
 
 生产环境下:
 用户需要用抓包工具、代理工具等自行获取device_token或者可以查看NSUserDefaults中的kUMessageUserDefaultKeyForParams的值。

 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSLog(@"#######%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
}

//iOS10以下使用这两个方法接收通知
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

#endif


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self isNeedUpdateNewVersion];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter]postNotificationName:kYbsSaveAnswerNotification object:nil];
}


@end
