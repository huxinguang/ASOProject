//
//  YbsAlertView.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/11.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsAlertView.h"

@interface YbsAlertView ()

@property (nonatomic, strong)WechatView *wechatView;
@property (nonatomic, assign)AlertViewType type;



@end


@implementation YbsAlertView

- (instancetype)initWithType:(AlertViewType)type delegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.type = type;
        self.delegate = delegate;
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews{
    if (self.type == AlertViewTypeWechat) {
        self.wechatView = [[WechatView alloc]initWithDelegate:self.delegate];
        [self addSubview:self.wechatView];
        self.wechatView.layer.cornerRadius = 12;
        self.wechatView.layer.masksToBounds = YES;
        [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(270*kYbsRatio, 219*kYbsRatio));
        }];
    }
    
}


#pragma mark - action

- (void)show{
    UIView *superView = [UIViewController currentViewController].navigationController.view;
    
    if (![superView.subviews containsObject:self]) {
        [superView addSubview:self];
        self.frame = CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight);
    }
    
    [self layoutIfNeeded];
    
    self.wechatView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.wechatView.transform = CGAffineTransformMakeScale(1, 1);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
    
//    [UIView animateWithDuration:0.3 animations:^{
//
//    } completion:^(BOOL finished) {
//
//    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.wechatView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)dealloc{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end




@implementation WechatView


- (instancetype)initWithDelegate:(id <YbsAlertViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate;
        [self buildSubViews];
        [self addConstraints];
    }
    return self;
}


- (void)buildSubViews{
    [self addSubview:self.closeBtn];
    [self addSubview:self.borderWhiteView];
    [self addSubview:self.iconImg];
    [self addSubview:self.companyLabel];
    [self addSubview:self.coopyBtn];
    [self addSubview:self.wechatLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.toWechatBtn];
    
    self.borderWhiteView.layer.cornerRadius = 3;
    self.borderWhiteView.layer.masksToBounds = YES;
    self.borderWhiteView.layer.borderColor = kColorHex(@"#D0D0D0").CGColor;
    self.borderWhiteView.layer.borderWidth = 0.5;
    
    self.iconImg.layer.cornerRadius = 3;
    self.iconImg.layer.masksToBounds = YES;
    
    self.coopyBtn.layer.cornerRadius = 3;
    self.coopyBtn.layer.masksToBounds = YES;
    
    self.toWechatBtn.layer.cornerRadius = 35*kYbsRatio/2;
    self.toWechatBtn.layer.masksToBounds = YES;

}

- (void)addConstraints{
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(5);
        make.right.equalTo(self).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.borderWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(40*kYbsRatio);
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.height.mas_equalTo(110*kYbsRatio);
    }];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.borderWhiteView).with.offset(23*kYbsRatio);
        make.left.equalTo(self.borderWhiteView).with.offset(12*kYbsRatio);
        make.size.mas_equalTo(CGSizeMake(40*kYbsRatio, 40*kYbsRatio));
    }];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg);
        make.left.equalTo(self.iconImg.mas_right).with.offset(7*kYbsRatio);
    }];
    
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.companyLabel);
        make.bottom.equalTo(self.iconImg);
    }];
    
    [self.coopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg);
        make.right.equalTo(self.borderWhiteView).with.offset(-20*kYbsRatio);
        make.size.mas_equalTo(CGSizeMake(40*kYbsRatio, 20*kYbsRatio));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImg.mas_bottom).with.offset(10*kYbsRatio);
        make.left.equalTo(self.borderWhiteView).with.offset(12*kYbsRatio);
        make.right.equalTo(self.borderWhiteView).with.offset(-12*kYbsRatio);
    }];
    
    [self.toWechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.borderWhiteView.mas_bottom).with.offset(20*kYbsRatio);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(110*kYbsRatio, 35*kYbsRatio));
    }];
    
}


- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:kImageNamed(@"alert_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIView *)borderWhiteView{
    if (!_borderWhiteView) {
        _borderWhiteView = [UIView new];
        _borderWhiteView.backgroundColor = [UIColor whiteColor];
    }
    return _borderWhiteView;
}

- (UIImageView *)iconImg{
    if (_iconImg==nil) {
        _iconImg=[[UIImageView alloc] init];
        _iconImg.image = kImageNamed(@"app_icon");
    }
    return _iconImg;
}

- (UILabel *)companyLabel{
    if (!_companyLabel) {
        _companyLabel=[[UILabel alloc] init];
        _companyLabel.text = @"云帮手小助手";
        _companyLabel.font=kYbsFontCustom(17);
        _companyLabel.textAlignment=NSTextAlignmentLeft;
        _companyLabel.textColor=kColorHex(@"#2F2F2F");
    }
    return _companyLabel;
}

- (UIButton *)coopyBtn{
    if (!_coopyBtn) {
        _coopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coopyBtn.backgroundColor = kColorHex(@"#FFA600");
        [_coopyBtn setTitle:@"复制" forState:UIControlStateNormal];
        _coopyBtn.titleLabel.font = kYbsFontCustom(13);
        [_coopyBtn addTarget:self action:@selector(coopyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coopyBtn;
}

- (UILabel *)wechatLabel{
    if (!_wechatLabel) {
        _wechatLabel=[[UILabel alloc] init];
        _wechatLabel.text = @"微信号：yun-bangshou";
        _wechatLabel.font=kYbsFontCustom(15);
        _wechatLabel.textAlignment=NSTextAlignmentLeft;
        _wechatLabel.textColor=kColorHex(@"#666666");
    }
    return _wechatLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel=[[UILabel alloc] init];
        _contentLabel.text = @"关注微信公众号，并绑定手机号，提现金额将以红包形式发给您";
        _contentLabel.font=kYbsFontCustom(11);
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        _contentLabel.textColor=kColorHex(@"#666666");
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

- (UIButton *)toWechatBtn{
    if (!_toWechatBtn) {
        _toWechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _toWechatBtn.backgroundColor = kColorHex(@"#FF2F29");
        [_toWechatBtn setTitle:@"去微信" forState:UIControlStateNormal];
        _toWechatBtn.titleLabel.font = kYbsFontCustom(17);
        [_toWechatBtn addTarget:self action:@selector(toWechatBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toWechatBtn;
}


#pragma mark - action

- (void)closeBtnAction{
    
    YbsAlertView *alert = (YbsAlertView *)self.superview;
    [alert dismiss];
    if ([self.delegate respondsToSelector:@selector(didClickClose)]) {
        [self.delegate didClickClose];
    }
    
}

- (void)coopyBtnAction{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *str = self.companyLabel.text;
    pasteboard.string = str;
    
    if ([self.delegate respondsToSelector:@selector(didClickBtnOne)]) {
        [self.delegate didClickBtnOne];
    }
}

- (void)toWechatBtnAction{
    if ([self.delegate respondsToSelector:@selector(didClickBtnTwo)]) {
        [self.delegate didClickBtnTwo];
    }
    
}

@end
