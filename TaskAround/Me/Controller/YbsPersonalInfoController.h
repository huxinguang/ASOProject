//
//  YbsPersonalInfoController.h
//  XGDemo
//
//  Created by 胡辉 on 2019/2/21.
//  Copyright © 2019 胡辉. All rights reserved.
//

#import "YbsBaseViewController.h"




NS_ASSUME_NONNULL_BEGIN

@interface YbsPersonalInfoController : YbsBaseViewController

@end


NS_ASSUME_NONNULL_END

typedef void(^ChooseBlock)(NSString *);

@interface YbsDatePicker : UIView

@property (nonatomic, copy  ) ChooseBlock chooseBlock;

- (instancetype)initWithBlock:(ChooseBlock)block;

- (void)show;
- (void)hide;

@end
