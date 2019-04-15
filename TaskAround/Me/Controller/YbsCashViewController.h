//
//  YbsCashViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YbsCashViewController : YbsBaseViewController

@property (nonatomic, copy  ) NSString *balance;
@property (nonatomic, copy  ) NSString *wechatNickname;
@property (nonatomic, copy  ) NSString *ruleContent;


@end

@interface CashModel : NSObject

@end



NS_ASSUME_NONNULL_END
