//
//  YbsMacro.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/18.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#ifndef YbsMacro_h
#define YbsMacro_h

//###########################👍 屏幕适配 👍###############################

#define kAppScreenWidth ([UIScreen mainScreen].bounds.size.width)//屏幕宽度
#define kAppScreenHeight ([UIScreen mainScreen].bounds.size.height)//屏幕高度
#define IS_Pad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) //判断是否是ipad
#define IS_iPhoneX_Or_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)//判断是否iPhone X/Xs
#define Is_iPhoneXr1 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)//判断iPHoneXr
#define Is_iPhoneXr2 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)//判断iPHoneXr
#define IS_iPhoneXs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !IS_Pad : NO)//判断iPhoneXs Max
#define IS_X_Series (IS_iPhoneX_Or_Xs || Is_iPhoneXr1 || Is_iPhoneXr2 || IS_iPhoneXs_Max) //判断是否为带刘海的iPhone

#define kAppStatusBarHeight (IS_X_Series ? 44.f : 20.f) //状态栏高度
#define kAppNavigationBarHeight 44.f //导航栏高度（不包含状态栏）.
#define kAppTabbarHeight (IS_X_Series ? (49.f+34.f) : 49.f)// Tabbar 高度.
#define kAppTabbarSafeBottomMargin (IS_X_Series ? 34.f : 0.f)// Tabbar 底部安全高度.
#define kAppStatusBarAndNavigationBarHeight (IS_X_Series ? 88.f : 64.f)// 状态栏和导航栏总高度.

#define kSizeScale  (kAppScreenWidth>1024?1.3339:1)


//###########################👍 AppDelegate 👍#############################

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//###########################👍 KeyWindow 👍###############################

#define kAppKeyWindow [UIApplication sharedApplication].keyWindow

//##############################👍 图 片 👍################################

#define kImageWithFile(_pointer) [UIImage imageWithContentsOfFile:[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"AssetPicker" ofType:@"bundle"]] pathForResource:[NSString stringWithFormat:@"%@@%dx",_pointer,(int)[UIScreen mainScreen].nativeScale] ofType:@"png"]]

#define kImageNamed(name) [UIImage imageNamed:name]

//##########################👍 NSUserDefault 👍###########################

#define kUserDefaultGet(key)                [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define kUserDefaultSet(object, key)        [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]
#define kUserDefaultRemove(key)             [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]
#define kUserDefaultSynchronize             [[NSUserDefaults standardUserDefaults] synchronize]

//########################### 👍 UIColor 👍 ###############################

#define kColorHex(hexString)     [UIColor colorWithHex:hexString]
#define kColorRGB(r,g,b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kColorRGBA(r,g,b,a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//############################ 👍 NSDate 👍 ###############################
#define kCurrentTimestampMillisecond  [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]*1000]
#define kCurrentTimestampSecond       [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]]

//############################ 👍 Alert 👍 ###############################
#define kShow_Alert(_msg_)  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:_msg_ preferredStyle:UIAlertControllerStyleAlert];\
[alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];\
[[[UIApplication sharedApplication].windows firstObject].rootViewController presentViewController:alertController animated:YES completion:nil];

//############################ 👍 应用配置 👍 ###############################

#define kYbsMD5Secret                       @"951d4c42326611e8a17f6c92bf3bb67f"
#define kYbsUserInfoDicKey                  @"kYbsUserInfoDicKey"



#define kYbsNavigationBarColor                  @"#ffa733"
#define kYbsThemeColor                          @"#fdbb40"
#define kYbsNavigationTitleViewTitleFontSize    20
#define kYbsNavigationTitleViewMaxWidth         220.f
#define kYbsNavigationTitleViewHeight           44.f
#define kYbsNavigationTitleViewTitleColor       @"#FFFFFF"
#define kYbsSizeScale                           (kAppScreenWidth/375)
//#define kYbsFontCustom(fontSize)                [UIFont systemFontOfSize:fontSize*kYbsSizeScale]

#define kYbsFontCustom(fontSize) [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize*kYbsSizeScale]

#define kYbsFontCustomBold(fontSize) [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize*kYbsSizeScale]

#define kYbsRatio                               (kAppScreenWidth/375)

#define kYbsUUIDKeychainKey                     @"kYbsUUIDKeychainKey"
#define kYbsIsFirstLaunchKey                    @"kYbsIsFirstLaunchKey"
#define kYbsIsFirstLaunchValue                  @"kYbsIsFirstLaunchValue"

#define kYbsTaskArchiverDirectory               @"taskArchivers" //已完成答题的
#define kYbsUndoneTaskArchiverDirectory         @"undoneTaskArchivers" //未完成答题的

#define kYbsCompressionQuality                  0.5

//############################ 👍 接口状态码 👍#############################

#define kYbsSuccess                             @"0000"
#define kYbsCodeKey                             @"code"
#define kYbsDataKey                             @"data"
#define kYbsMsgKey                              @"message"
#define kYbsTokenExpired                        @"5555"
#define kYbsRequestFailed                       @"请求失败"

//############################## 👍 通知 👍 ###############################

#define kYbsSaveAnswerNotification   @"kYbsSaveAnswerNotification"

//############################ 👍 第三方SDK 👍##############################

#define kQCloudAppID                          @"1258434628"
#define kQCloudRegion                         @"ap-beijing"
#define kQCloudSecretID                         @"AKIDd4GDuLxR6VeXAXqlVyGK9i1LQFo7dzYs"
#define kQCloudSecretKey                        @"ECwTmpdBVaPzKUP4UpvlLhofAQSEl23o"

#define kQCloudBucket                         @"yunbangshou-cos-1258434628"
#define kQCloudTestBucket                     @"yunbangshou-cos-test-1258434628"

#define kBuglyAppID                           @"61f55aada7"
#define kBuglyAppKey                          @"d3c9de1b-f2ab-405b-8cbf-f55f70596bce"
//#define kYbsAMapKey                           @"7e7bb71d955144ec1530e5843b135ced"
#define kYbsAMapKey                           @"56c60936bb7f710be3528d94a87768f2"


#define kUMPushAppkey                         @"5cac33133fc195968d001a22"


/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
//#define kGtAppId           @"zuGIBQNoAo8EPgcNI52Q18"
//#define kGtAppKey          @"bAyknCYsTr8qRwOonA0EN1"
//#define kGtAppSecret       @"BfoyYR9u1S86TPkqbS4Ob5"


#endif /* YbsMacro_h */
