//
//  YbsChangePhoneViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/23.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsChangePhoneViewController.h"
#import "NSTimer+FY.h"

@interface YbsChangePhoneViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *whiteBgView1;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UIImageView *smallVerticalLine1;
@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UIView *whiteBgView2;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIImageView *smallVerticalLine2;
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UIView *phoneBottomLine;

@property (nonatomic, strong) UIView *whiteBgView3;
@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIButton *commitBtn;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int seconds;
@property (nonatomic, assign) BOOL timerFired;

@end

@implementation YbsChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"修改手机号码"];
    [self buildSubViews];
    [self addConstraints];
}

- (void)buildSubViews{
    [self.view addSubview:self.whiteBgView1];
    [self.whiteBgView1 addSubview:self.currentLabel];
    [self.whiteBgView1 addSubview:self.smallVerticalLine1];
    [self.whiteBgView1 addSubview:self.phoneLabel];
    
    [self.view addSubview:self.whiteBgView2];
    [self.whiteBgView2 addSubview:self.phoneTextField];
    [self.whiteBgView2 addSubview:self.smallVerticalLine2];
    [self.whiteBgView2 addSubview:self.codeBtn];
    [self.whiteBgView2 addSubview:self.phoneBottomLine];
    
    [self.view addSubview:self.whiteBgView3];
    [self.whiteBgView3 addSubview:self.codeTextField];
    
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.contentLabel];
    
    [self.view addSubview:self.commitBtn];
}


- (void)addConstraints{
    [self.whiteBgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBgView1);
        make.left.equalTo(self.whiteBgView1).with.offset(10);
    }];
    
    [self.smallVerticalLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBgView1);
        make.left.equalTo(self.currentLabel.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(1, 33));
    }];
    
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBgView1);
        make.left.equalTo(self.smallVerticalLine1.mas_right).with.offset(10);
    }];
    
    [self.whiteBgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView1.mas_bottom).with.offset(10);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBgView2);
        make.left.equalTo(self.whiteBgView2).with.offset(10);
        make.right.equalTo(self.smallVerticalLine2.mas_left).with.offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.smallVerticalLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBgView2);
        make.right.equalTo(self.codeBtn.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(1, 20));
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBgView2);
        make.right.equalTo(self.whiteBgView2).with.offset(-10);
        make.width.mas_equalTo(80*kYbsRatio);
    }];
    
    [self.phoneBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.whiteBgView2).with.offset(10);
        make.right.equalTo(self.whiteBgView2);
        make.bottom.equalTo(self.whiteBgView2);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.whiteBgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView2.mas_bottom);
        make.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.whiteBgView3);
        make.left.equalTo(self.whiteBgView3).with.offset(10);
        make.right.equalTo(self.whiteBgView3).with.offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.whiteBgView3.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.tipLabel);
        make.right.equalTo(self.view).with.offset(-10);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-kAppTabbarSafeBottomMargin);
        make.height.mas_equalTo(40);
    }];
    
}

#pragma mark - setter

-(void)setSeconds:(int)seconds{
    _seconds = seconds;
    self.timerFired = YES;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%d",self.seconds] forState:UIControlStateNormal];
}


#pragma mark - getter

- (UIView *)whiteBgView1{
    if (!_whiteBgView1) {
        _whiteBgView1 = [UIView new];
        _whiteBgView1.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView1;
}

- (UILabel *)currentLabel{
    if (!_currentLabel) {
        _currentLabel = [UILabel new];
        _currentLabel.text = @"当前绑定手机是";
        _currentLabel.font = kYbsFontCustom(20);
        _currentLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _currentLabel;
}

- (UIImageView *)smallVerticalLine1{
    if (!_smallVerticalLine1) {
        _smallVerticalLine1 = [UIImageView new];
        _smallVerticalLine1.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _smallVerticalLine1;
}

- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel = [UILabel new];
        _phoneLabel.font = kYbsFontCustom(20);
        _phoneLabel.textColor = kColorHex(@"#2F2F2F");
        NSString *mobile = kUserDefaultGet(kYbsUserInfoDicKey)[@"mobile"];
        NSMutableString *mutStr = [[NSMutableString alloc]initWithString:mobile];
        [mutStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        _phoneLabel.text = mutStr;
    }
    return _phoneLabel;
}

- (UIView *)whiteBgView2{
    if (!_whiteBgView2) {
        _whiteBgView2 = [UIView new];
        _whiteBgView2.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView2;
}

- (UITextField *)phoneTextField{
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc]init];
        _phoneTextField.tag = 0;
        _phoneTextField.textColor = kColorHex(@"#2F2F2F");
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.placeholder = @"请输入新的手机号";
        _phoneTextField.delegate = self;
        _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneTextField.font = kYbsFontCustom(15);
        [_phoneTextField addTarget:self action:@selector(onTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _phoneTextField;
}

- (UIImageView *)smallVerticalLine2{
    if (!_smallVerticalLine2) {
        _smallVerticalLine2 = [UIImageView new];
        _smallVerticalLine2.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _smallVerticalLine2;
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

- (UIView *)whiteBgView3{
    if (!_whiteBgView3) {
        _whiteBgView3 = [UIView new];
        _whiteBgView3.backgroundColor = [UIColor whiteColor];
    }
    return _whiteBgView3;
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

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.backgroundColor = kColorHex(@"#FF2F29");
        [_commitBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.enabled = NO;
        _commitBtn.alpha = 0.5;
    }
    return _commitBtn;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.text = @"温馨提示：";
        _tipLabel.font = kYbsFontCustomBold(15);
        _tipLabel.textColor = kColorHex(@"#6B6B6B");
    }
    return _tipLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.text = @"1.更改手机号码不影响您的帐户钱包信息；\n2.更改后请使用新的手机号码登录；\n3.更改后，若您已在“云帮手”微信公众号绑定过您的旧手机号码，请务必前往微信公众号换绑您的新手机号。";
        _contentLabel.font = kYbsFontCustom(13);
        _contentLabel.textColor = kColorHex(@"#A3A3A3");
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}



#pragma mark - Action

- (void)getCodeAction{
    
    if (self.timerFired) {
        return;
    }
    
    self.timer = [NSTimer fy_timerWithTimeInterval:1 target:self selector:@selector(syncTime) userInfo:nil runLoopMode:NSRunLoopCommonModes repeats:YES];
    self.seconds = 60;
    
    NSDictionary *parameterDic = @{
                                   @"mobile":self.phoneTextField.text,
                                   @"type":@1
                                   };
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi verificationCodeUrl]
                              parameters:parameterDic
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[@"code"] isEqualToString:kYbsSuccess]){
                                         [self showMessage:@"验证码已发送" hideDelay:1.0];
                                     } else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     [self showMessage:kYbsRequestFailed hideDelay:1.0];
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

- (void)commitBtnAction{
    
    NSDictionary *parameterDic = @{
                                   @"mobile":self.phoneTextField.text,
                                   @"verifyCode":self.codeTextField.text
                                   };
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi updatePhoneUrl]
                              parameters:parameterDic
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[@"code"] isEqualToString:kYbsSuccess]){
                                         NSString *prefix = [self.phoneTextField.text substringToIndex:3];
                                         NSString *suffix = [self.phoneTextField.text substringFromIndex:7];
                                         NSString *nickname = [NSString stringWithFormat:@"%@****%@",prefix,suffix];
                                         
                                         NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:kUserDefaultGet(kYbsUserInfoDicKey)];
                                         [dic setObject:nickname forKey:@"nickName"];
                                         kUserDefaultSet(dic, kYbsUserInfoDicKey);
                                         kUserDefaultSynchronize;
                                         
                                         [self.navigationController popViewControllerAnimated:YES];
                                         [self showMessage:@"修改手机号成功" hideDelay:1.0];
                                         
                                     } else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                 }
                                 failure:^(NSError * _Nonnull error) {
//                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                 }
     ];
    
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
    
    if (self.phoneTextField.text.length == 11 && self.codeTextField.text.length >0) {
        self.commitBtn.enabled = YES;
        self.commitBtn.alpha = 1;
    }else{
        self.commitBtn.enabled = NO;
        self.commitBtn.alpha = 0.5;
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
