//
//  YbsApi.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/16.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsApi.h"

static NSString *const baseReleaseUrl           = @"https://api.yun-bangshou.com:8088/";
static NSString *const baseDebugUrl             = @"http://62.234.107.96:8088/";
static NSString *const baseTestUrl              = @"http://62.234.107.173:8088/";


@implementation YbsApi

/**
 * 获取base Url
 */
+ (NSString *)baseUrl{
    return [self baseTestUrl];
}

/**
 * 获取release Url
 */
+ (NSString *)baseReleaseUrl{
    return baseReleaseUrl;
}

/**
 * 获取debug Url
 */
+ (NSString *)baseDebugUrl{
    return baseDebugUrl;
}


/**
 * 获取test Url
 */
+ (NSString *)baseTestUrl{
    return baseTestUrl;
}


/**
 * (登录) 获取验证码
 */

+ (NSString *)verificationCodeUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/getVerifyCode"];
}

/**
 * 用户登录
 */
+ (NSString *)userLoginUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/login"];
}

/**
 * 获取周边任务(地图)
 */
+ (NSString *)tasksInMapUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryTaskListForMap"];
}

/**
 * 获取任务列表
 */
+ (NSString *)taskListUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryTaskList"];
}

/**
 * 获取任务详情
 */
+ (NSString *)taskDetailUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryTask"];
}

/**
 * 获取问题
 */
+ (NSString *)taskQuestionUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryQuestionList"];
}

/**
 * 稍后提交
 */
+ (NSString *)taskSubmitLaterUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/addAnswerStay"];
}

/**
 * 任务提交
 */
+ (NSString *)taskSubmitUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/addAnswer"];
}

/**
 * 钱包余额
 */
+ (NSString *)walletBalanceUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/money/queryMoneyDetail"];
}

/**
 * 提现
 */
+ (NSString *)withdrawDepositUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/money/addDrawCash"];
}

/**
 * 待提交
 */
+ (NSString *)taskUnCommitUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryAnswerStayList"];
}

/**
 * 待审核
 */
+ (NSString *)taskUnReviewUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryWaitCheckAnswerList"];
}

/**
 * 待申诉
 */
+ (NSString *)taskUnAppealUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryWaitAppealAnswerList"];
}

/**
 * 历史任务
 */
+ (NSString *)taskHistoryUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryHistoryAnswerList"];
}

/**
 * 修改手机号
 */
+ (NSString *)updatePhoneUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/user/modifyUserMobile"];
}

/**
 * 修改用户信息
 */
+ (NSString *)updateUserInfoUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/user/modifyUser"];
}


/**
 * 获取不合格原因
 */
+ (NSString *)unqualifiedReasonUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/queryFirstCheckDetail"];
}

/**
 * 申诉
 */
+ (NSString *)appealUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/task/addAnswerAppeal"];
}

/**
 * 退出登录
 */
+ (NSString *)logoutUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/logout"];
}

/**
 * 余额明细
 */
+ (NSString *)balanceDetailUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/money/queryTransactionList"];
}

/**
 * 任务预览
 */
+ (NSString *)taskPreviewUrl{
    return [NSString stringWithFormat:@"%@%@",@"https://admin.yun-bangshou.com:8090/",@"#/Preview?taskId="];
}


/**
 * 新手指南
 */
+ (NSString *)howToUseUrl{
    return [NSString stringWithFormat:@"%@%@",@"https://admin.yun-bangshou.com:8099/",@"xs/index.html"];
}

/**
 * 是否关注微信公众号
 */
+ (NSString *)ifFollowWechatUrl{
    return [NSString stringWithFormat:@"%@%@",[self baseUrl],@"app/user/queryFollowPublicCode"];
}

/**
 * 用户协议
 */
+ (NSString *)userAgreementUrl{
    return [NSString stringWithFormat:@"%@%@",@"https://admin.yun-bangshou.com:8099/",@"agreement/index.html"];
}


@end
