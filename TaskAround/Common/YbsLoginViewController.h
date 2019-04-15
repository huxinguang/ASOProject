//
//  YbsLoginViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/23.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsBaseViewController.h"

typedef void(^LoginSuccessBlock)(void);
typedef void(^LoginVisitorBlock)(void);


NS_ASSUME_NONNULL_BEGIN

@interface YbsLoginViewController : YbsBaseViewController

@property (nonatomic, strong) LoginSuccessBlock successBlock;
@property (nonatomic, strong) LoginVisitorBlock visitorBlock;


@end

NS_ASSUME_NONNULL_END
