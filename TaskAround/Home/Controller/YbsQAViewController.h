//
//  YbsQAViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/30.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsBaseViewController.h"
#import "YbsTaskModel.h"
#import "YbsQueModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YbsQAViewController : YbsBaseViewController

@property (nonatomic, strong) NSArray <YbsQueModel *> *questionArray;
@property (nonatomic, strong) YbsTaskModel *taskModel;
@property (nonatomic, strong) UITableView *tableView;
- (void)previousPageAction;
- (void)nextPageAction;

@end

NS_ASSUME_NONNULL_END
