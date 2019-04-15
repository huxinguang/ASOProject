//
//  YbsWelcomeViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/28.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StartBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface YbsWelcomeViewController : UIViewController

@property (nonatomic, copy) StartBlock startBlock;

- (instancetype)initWithBlock:(StartBlock)block;

@end

NS_ASSUME_NONNULL_END
