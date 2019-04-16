//
//  YbsApi.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/16.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsApi : NSObject

+ (NSString *)baseUrl;

+ (NSString *)baseReleaseUrl;

+ (NSString *)baseDebugUrl;

+ (NSString *)verificationCodeUrl;

+ (NSString *)userLoginUrl;

+ (NSString *)tasksInMapUrl;

+ (NSString *)taskListUrl;

+ (NSString *)taskDetailUrl;

+ (NSString *)taskQuestionUrl;

+ (NSString *)taskSubmitLaterUrl;

+ (NSString *)taskSubmitUrl;

+ (NSString *)walletBalanceUrl;

+ (NSString *)withdrawDepositUrl;

+ (NSString *)taskUnCommitUrl;

+ (NSString *)taskUnReviewUrl;

+ (NSString *)taskUnAppealUrl;

+ (NSString *)taskHistoryUrl;

+ (NSString *)updatePhoneUrl;

+ (NSString *)updateUserInfoUrl;

+ (NSString *)unqualifiedReasonUrl;

+ (NSString *)appealUrl;

+ (NSString *)logoutUrl;

+ (NSString *)balanceDetailUrl;

+ (NSString *)taskPreviewUrl;

+ (NSString *)howToUseUrl;

+ (NSString *)ifFollowWechatUrl;

+ (NSString *)userAgreementUrl;

+ (NSString *)messageListUrl;

+ (NSString *)messageDetailUrl;

+ (NSString *)helpUrl;



@end

NS_ASSUME_NONNULL_END
