//
//  YbsQuestionViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/30.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PageChangeBlock)(NSInteger);

NS_ASSUME_NONNULL_BEGIN

@interface YbsQuestionViewController : UIViewController

@property (nonatomic, copy) PageChangeBlock pageBlock;

@end

NS_ASSUME_NONNULL_END
