//
//  YbsHomeViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsBaseViewController.h"
#import "YbsTaskMapViewController.h"
#import "YbsTaskListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YbsHomeViewController : YbsBaseViewController

@property (nonatomic, strong) YbsTaskMapViewController *mvc;
@property (nonatomic, strong) YbsTaskListViewController *lvc;
@property (nonatomic, strong) UIViewController *currentVC;

@end

NS_ASSUME_NONNULL_END
