//
//  YbsAlertView.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/11.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,AlertViewType) {
    AlertViewTypeWechat,
    AlertViewTypeOther
};

@protocol YbsAlertViewDelegate <NSObject>

- (void)didClickClose;
- (void)didClickBtnOne;
- (void)didClickBtnTwo;


@end


NS_ASSUME_NONNULL_BEGIN

@interface YbsAlertView : UIView

@property (nonatomic, weak) id <YbsAlertViewDelegate> delegate;

- (instancetype)initWithType:(AlertViewType)type delegate:(id)delegate;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END

@interface WechatView : UIView

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIView *borderWhiteView;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) UIButton *coopyBtn;
@property (nonatomic, strong) UILabel *wechatLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *toWechatBtn;
@property (nonatomic, weak  ) id <YbsAlertViewDelegate> delegate;

- (instancetype)initWithDelegate:(id <YbsAlertViewDelegate>)delegate;

@end
