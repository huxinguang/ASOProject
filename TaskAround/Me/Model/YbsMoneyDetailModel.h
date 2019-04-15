//
//  YbsMoneyDetailModel.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/9.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsMoneyDetailModel : NSObject

@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, copy  ) NSString *taskName;
@property (nonatomic, copy  ) NSString *money;
@property (nonatomic, copy  ) NSString *moneyType;
@property (nonatomic, copy  ) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
