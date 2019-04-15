//
//  YbsLoginViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/23.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsLoginViewController.h"
#import "YbsWebViewController.h"
#import "YbsTabBarController.h"
#import "NSDictionary+YbsObject.h"
#import "NSTimer+FY.h"

@interface YbsLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *appIconImgView;
@property (nonatomic, strong) UIImageView *phoneImgView;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIImageView *smallVerticalLine;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIView *phoneBottomLine;

@property (nonatomic, strong) UIImageView *msgImgView;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIView *msgBottomLine;

@property (nonatomic, strong) UIButton *checkBox;
@property (nonatomic, strong) UILabel *agreementLabel;
@property (nonatomic, strong) UIButton *agreementBtn;

@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *lookBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int seconds;
@property (nonatomic, assign) BOOL timerFired;

@end

@implementation YbsLoginViewController

- (void)configLeftBarButtonItem{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildSubViews];
    [self addConstraints];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)buildSubViews{
    [self.view addSubview:self.appIconImgView];
    [self.view addSubview:self.phoneImgView];
    [self.view addSubview:self.phoneTextField];
    [self.view addSubview:self.smallVerticalLine];
    [self.view addSubview:self.codeBtn];
    [self.view addSubview:self.phoneBottomLine];
    [self.view addSubview:self.msgImgView];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.msgBottomLine];
    [self.view addSubview:self.checkBox];
    [self.view addSubview:self.agreementLabel];
    [self.view addSubview:self.agreementBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.lookBtn];
    self.loginBtn.layer.cornerRadius = 3;
    self.loginBtn.layer.masksToBounds = YES;

}

- (void)addConstraints{
    [self.appIconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(53 + kAppStatusBarHeight);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(68*kYbsRatio, 68*kYbsRatio));
    }];
    
    [self.phoneBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appIconImgView.mas_bottom).with.offset(95*kYbsRatio);
        make.left.equalTo(self.view).with.offset(30*kYbsRatio);
        make.right.equalTo(self.view).with.offset(-30*kYbsRatio);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneBottomLine);
        make.bottom.equalTo(self.phoneBottomLine.mas_top).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(14, 21.5));
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImgView.mas_right).with.offset(8);
        make.centerY.equalTo(self.phoneImgView);
        make.right.equalTo(self.smallVerticalLine.mas_left).with.offset(-5);
        make.height.mas_equalTo(30);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.phoneBottomLine);
        make.centerY.equalTo(self.phoneImgView);
        make.height.equalTo(self.phoneImgView);
        make.width.mas_equalTo(80*kYbsRatio);
    }];
    
    [self.smallVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.codeBtn.mas_left).with.offset(-7);
        make.centerY.equalTo(self.codeBtn);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    
    [self.msgBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneBottomLine.mas_bottom).with.offset(80*kYbsRatio);
        make.left.equalTo(self.view).with.offset(30*kYbsRatio);
        make.right.equalTo(self.view).with.offset(-30*kYbsRatio);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [self.msgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgBottomLine);
        make.bottom.equalTo(self.msgBottomLine.mas_top).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(18, 14.5));
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgImgView.mas_right).with.offset(8);
        make.centerY.equalTo(self.msgImgView);
        make.right.equalTo(self.msgBottomLine);
        make.height.mas_equalTo(30);
    }];
    
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.msgBottomLine.mas_bottom).with.offset(44);
        make.left.equalTo(self.msgBottomLine);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkBox);
        make.left.equalTo(self.checkBox.mas_right).with.offset(3);
    }];
    
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkBox);
        make.left.equalTo(self.agreementLabel.mas_right);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkBox.mas_bottom).with.offset(25*kYbsRatio);
        make.left.equalTo(self.msgBottomLine);
        make.right.equalTo(self.msgBottomLine);
        make.height.mas_equalTo(40*kYbsRatio);
    }];
    
    [self.lookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).with.offset(22);
        make.right.equalTo(self.loginBtn);
    }];
    
}

#pragma mark - setter

-(void)setSeconds:(int)seconds{
    _seconds = seconds;
    self.timerFired = YES;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%d",self.seconds] forState:UIControlStateNormal];
}

#pragma mark - getter

- (UIImageView *)appIconImgView{
    if (!_appIconImgView) {
        _appIconImgView = [UIImageView new];
        _appIconImgView.image = kImageNamed(@"app_icon");
    }
    return _appIconImgView;
}

- (UIImageView *)phoneImgView{
    if (!_phoneImgView) {
        _phoneImgView = [UIImageView new];
        _phoneImgView.image = kImageNamed(@"login_phone");
    }
    return _phoneImgView;
}

- (UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.tag = 0;
        _phoneTextField.textColor = kColorHex(@"#2F2F2F");
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.placeholder = @"请输入您的手机号";
        _phoneTextField.delegate = self;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.font = kYbsFontCustom(15);
        [_phoneTextField addTarget:self action:@selector(onTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTextField;
}

- (UIImageView *)smallVerticalLine{
    if (!_smallVerticalLine) {
        _smallVerticalLine = [UIImageView new];
        _smallVerticalLine.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _smallVerticalLine;
}

- (UIButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.titleLabel.font = kYbsFontCustom(15);
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:kColorHex(@"#FF6700") forState:UIControlStateNormal];
        [_codeBtn setTitleColor:kColorHex(@"#999999") forState:UIControlStateDisabled];
        [_codeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.enabled = NO;
        
    }
    return _codeBtn;
}

- (UIView *)phoneBottomLine{
    if (!_phoneBottomLine) {
        _phoneBottomLine = [UIView new];
        _phoneBottomLine.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _phoneBottomLine;
}

- (UIImageView *)msgImgView{
    if (!_msgImgView) {
        _msgImgView = [UIImageView new];
        _msgImgView.image = kImageNamed(@"login_msg");
    }
    return _msgImgView;
}

- (UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.tag = 1;
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.textColor = kColorHex(@"#2F2F2F");
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.delegate = self;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.font = kYbsFontCustom(15);
        [_codeTextField addTarget:self action:@selector(onTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _codeTextField;
}

- (UIView *)msgBottomLine{
    if (!_msgBottomLine) {
        _msgBottomLine = [UIView new];
        _msgBottomLine.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _msgBottomLine;
}

- (UIButton *)checkBox{
    if (!_checkBox) {
        _checkBox = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBox setImage:kImageNamed(@"login_check_normal") forState:UIControlStateNormal];
        [_checkBox setImage:kImageNamed(@"login_check_selected") forState:UIControlStateSelected];
        [_checkBox addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBox;
}

- (UILabel *)agreementLabel{
    if (!_agreementLabel) {
        _agreementLabel = [UILabel new];
        _agreementLabel.text = @"我已阅读并同意";
        _agreementLabel.font = kYbsFontCustom(13);
        _agreementLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _agreementLabel;
}

- (UIButton *)agreementBtn{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreementBtn.titleLabel.font = kYbsFontCustom(13);
        [_agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
        [_agreementBtn setTitleColor:kColorHex(@"#FF6700") forState:UIControlStateNormal];
        [_agreementBtn addTarget:self action:@selector(agreementClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _agreementBtn;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = kColorHex(@"#FF6700");
        _lookBtn.titleLabel.font = kYbsFontCustom(17);
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.enabled = NO;
        _loginBtn.alpha = 0.5;
    }
    return _loginBtn;
}

- (UIButton *)lookBtn{
    if (!_lookBtn) {
        _lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookBtn.titleLabel.font = kYbsFontCustom(15);
        [_lookBtn setTitle:@"随便看看" forState:UIControlStateNormal];
        [_lookBtn setTitleColor:kColorHex(@"#BBBBBB") forState:UIControlStateNormal];
        [_lookBtn addTarget:self action:@selector(lookBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lookBtn;
}

#pragma mark - Action

- (void)getCodeAction{
    [self.phoneTextField resignFirstResponder];
    if (self.timerFired) {
        return;
    }
    
    self.timer = [NSTimer fy_timerWithTimeInterval:1 target:self selector:@selector(syncTime) userInfo:nil runLoopMode:NSRunLoopCommonModes repeats:YES];
    self.seconds = 60;

    NSDictionary *parameterDic = @{
                                   @"mobile":self.phoneTextField.text,
                                   @"type":@0
                                   };
    [MBProgressHUD showLoadingInView];

    [[YbsNetworkUtil shareInstance] POST:[YbsApi verificationCodeUrl]
                              parameters:parameterDic
                                 success:^(id  _Nonnull responseObject) {
                                     [MBProgressHUD hideHUD];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[@"code"] isEqualToString:kYbsSuccess]){
                                         [MBProgressHUD showTipInViewWithMessage:@"验证码已发送" hideDelay:1.0];
                                         
                                     } else{
                                         [MBProgressHUD showTipInViewWithMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                         
                                     }
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     [MBProgressHUD showTipInViewWithMessage:kYbsRequestFailed hideDelay:1.0];
                                     
                                     
                                 }
     ];
}

- (void)syncTime{
    if (self.seconds == 0) {
        [self.codeBtn setTitle:@"重发验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        self.timerFired = NO;
        return;
    }
    self.seconds = self.seconds - 1;
}


- (void)checkAction{
    self.checkBox.selected = !self.checkBox.selected;
    if (self.checkBox.selected && self.phoneTextField.text.length == 11 && self.codeTextField.text.length >0) {
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 1;
    }else{
        self.loginBtn.enabled = NO;
        self.loginBtn.alpha = 0.5;
    }
}

- (void)agreementClick{
    YbsWebViewController *wvc = [[YbsWebViewController alloc]init];
    wvc.pageTitle = @"用户协议";
    wvc.pageUrl = [YbsApi userAgreementUrl];
    [self.navigationController pushViewController:wvc animated:YES];
}

- (void)loginBtnAction{
    
    NSDictionary *parameterDic = @{
                                   @"mobile":self.phoneTextField.text,
                                   @"verifyCode":self.codeTextField.text
                                   };
    [MBProgressHUD showLoadingInView];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi userLoginUrl]
                              parameters:parameterDic
                                 success:^(id  _Nonnull responseObject) {
                                     [MBProgressHUD hideHUD];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]){
                                         NSDictionary *userDic = [dic[kYbsDataKey] convertNullValueToEmptyStr];
                                         kUserDefaultRemove(kYbsUserInfoDicKey);
                                         kUserDefaultSet(userDic, kYbsUserInfoDicKey);
                                         kUserDefaultSynchronize;
                                        
                                         [MBProgressHUD showTipInViewWithMessage:@"登录成功" hideDelay:1.0];
                                        
                                         if (self.successBlock) {
                                             self.successBlock();
                                         }
                                     } else{
                                         [MBProgressHUD showTipInViewWithMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     [MBProgressHUD hideHUD];
                                     [MBProgressHUD showTipInViewWithMessage:kYbsRequestFailed hideDelay:1.0];
                                 }
     ];

}

- (void)lookBtnAction{
    
    if (self.visitorBlock) {
        self.visitorBlock();
    }
}

#pragma mark - TextChanged

- (void)onTextChanged:(UITextField *)textField{
    if (textField.tag == 0) {
        if (textField.text.length == 11) {
            self.codeBtn.enabled = YES;
        }else{
            if (textField.text.length > 11) {
                textField.text = [textField.text substringToIndex:11];
                self.codeBtn.enabled = YES;
            }else{
                self.codeBtn.enabled = NO;
            }
        }
        
    }
    
    if (self.phoneTextField.text.length == 11 && self.codeTextField.text.length >0 && self.checkBox.selected) {
        self.loginBtn.enabled = YES;
        self.loginBtn.alpha = 1;
    }else{
        self.loginBtn.enabled = NO;
        self.loginBtn.alpha = 0.5;
    }

}


#pragma mark - life circle

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
