//
//  YbsCashViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsCashViewController.h"

@interface YbsCashViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *topBgView;            // 顶部灰色背景
@property (nonatomic, strong) UILabel *cashToLabel;         // ”提现至微信账号“
@property (nonatomic, strong) UILabel *wechatLabel;         // "快乐小猪"
@property (nonatomic, strong) UILabel *amountLabel;         // ”提现金额“
@property (nonatomic, strong) UILabel *moneyIconLabel;      // "￥"
@property (nonatomic, strong) UITextField *textField;       // 输入框
@property (nonatomic, strong) UIView *lineView;             // 分割线
@property (nonatomic, strong) UILabel *walletLabel;         // ”钱包金额“
@property (nonatomic, strong) UIButton *cashBtn;            // 提现按钮
@property (nonatomic, strong) UIView *bottomBgView;         // 底部灰色背景
@property (nonatomic, strong) UILabel *cashRuleLabel;       // 提现规则
@property (nonatomic, strong) UILabel *ruleContentLabel;    // 规则内容
@property (nonatomic, assign) BOOL isHaveDian;


@end

@implementation YbsCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"提现申请"];
    [self buildSubViews];
    [self addConstraints];
    self.walletLabel.text = [NSString stringWithFormat:@"钱包金额：%@",self.balance];
}

- (void)buildSubViews{
    [self.view addSubview:self.topBgView];
    [self.view addSubview:self.cashToLabel];
    [self.view addSubview:self.wechatLabel];
    [self.view addSubview:self.amountLabel];
    [self.view addSubview:self.moneyIconLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.walletLabel];
    [self.view addSubview:self.cashBtn];
    self.cashBtn.layer.cornerRadius = 3;
    self.cashBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.bottomBgView];
    [self.view addSubview:self.cashRuleLabel];
    [self.view addSubview:self.ruleContentLabel];
    
}

- (void)addConstraints{
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(63);
    }];
    
    [self.cashToLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(21);
        make.left.equalTo(self.view).with.offset(10);
    }];
    
    [self.wechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cashToLabel.mas_right);
        make.centerY.equalTo(self.cashToLabel);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cashToLabel.mas_bottom).with.offset(54);
        make.left.equalTo(self.cashToLabel);
    }];
    
    [self.moneyIconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cashToLabel.mas_bottom).with.offset(98);
        make.left.equalTo(self.cashToLabel);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.moneyIconLabel);
        make.left.equalTo(self.moneyIconLabel.mas_right).with.offset(10);
        make.right.equalTo(self.view).with.offset(30);
        make.height.mas_equalTo(40);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyIconLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.moneyIconLabel);
        make.right.equalTo(self.view).with.offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.walletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(25);
        make.left.equalTo(self.lineView);
    }];
    
    [self.cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletLabel.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(138, 40));
    }];
    
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cashBtn.mas_bottom).with.offset(35);
        make.left.and.bottom.and.right.equalTo(self.view);
    }];
    
    [self.cashRuleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomBgView).with.offset(20);
        make.left.equalTo(self.cashToLabel);
    }];
    
    [self.ruleContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cashRuleLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.cashToLabel);
        make.right.equalTo(self.view).with.offset(-10);
    }];
    
}

- (UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [UIView new];
        _topBgView.backgroundColor = kColorHex(@"#F9F9F9");
    }
    return _topBgView;
}

- (UILabel *)cashToLabel{
    if (!_cashToLabel) {
        _cashToLabel=[[UILabel alloc] init];
        _cashToLabel.text = @"提现至微信账号：";
        _cashToLabel.font=kYbsFontCustom(15);
        _cashToLabel.textAlignment=NSTextAlignmentRight;
        _cashToLabel.textColor=kColorHex(@"#2F2F2F");
    }
    return _cashToLabel;
}

- (UILabel *)wechatLabel{
    if (!_wechatLabel) {
        _wechatLabel=[[UILabel alloc] init];
        _wechatLabel.text = self.wechatNickname;
        _wechatLabel.font=kYbsFontCustomBold(18);
        _wechatLabel.textAlignment=NSTextAlignmentLeft;
        _wechatLabel.textColor=kColorHex(@"#2F2F2F");
    }
    return _wechatLabel;
}


- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel=[[UILabel alloc] init];
        _amountLabel.text = @"提现金额";
        _amountLabel.font=kYbsFontCustom(14);
        _amountLabel.textAlignment=NSTextAlignmentLeft;
        _amountLabel.textColor=kColorHex(@"#2F2F2F");
    }
    return _amountLabel;
}


- (UILabel *)moneyIconLabel{
    if (!_moneyIconLabel) {
        _moneyIconLabel=[[UILabel alloc] init];
        _moneyIconLabel.text = @"￥";
        _moneyIconLabel.font=kYbsFontCustomBold(32);
        _moneyIconLabel.textAlignment=NSTextAlignmentLeft;
        _moneyIconLabel.textColor=kColorHex(@"#2F2F2F");
    }
    return _moneyIconLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.font = kYbsFontCustomBold(46);
        [_textField addTarget:self action:@selector(onTextChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorHex(@"#979797");
    }
    return _lineView;
}

- (UILabel *)walletLabel{
    if (!_walletLabel) {
        _walletLabel=[[UILabel alloc] init];
        _walletLabel.text = @"";
        _walletLabel.font=kYbsFontCustom(14);
        _walletLabel.textAlignment=NSTextAlignmentLeft;
        _walletLabel.textColor=kColorHex(@"#8F8F8F");
    }
    return _walletLabel;
}

- (UIButton *)cashBtn{
    if (!_cashBtn) {
        _cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cashBtn.backgroundColor = kColorHex(@"#FF2F29");
        [_cashBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_cashBtn addTarget:self action:@selector(cashBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _cashBtn.enabled = NO;
        _cashBtn.alpha = 0.5;
    }
    return _cashBtn;
}

- (UIView *)bottomBgView{
    if (!_bottomBgView) {
        _bottomBgView = [UIView new];
        _bottomBgView.backgroundColor = kColorHex(@"#EFEFEF");
    }
    return _bottomBgView;
}

- (UILabel *)cashRuleLabel{
    if (!_cashRuleLabel) {
        _cashRuleLabel=[[UILabel alloc] init];
        _cashRuleLabel.text = @"提现规则：";
        _cashRuleLabel.font=kYbsFontCustomBold(15);
        _cashRuleLabel.textAlignment=NSTextAlignmentLeft;
        _cashRuleLabel.textColor=kColorHex(@"#6B6B6B");
    }
    return _cashRuleLabel;
}

- (UILabel *)ruleContentLabel{
    if (!_ruleContentLabel) {
        _ruleContentLabel=[[UILabel alloc] init];
        _ruleContentLabel.text = self.ruleContent ? self.ruleContent : @"";
        _ruleContentLabel.font=kYbsFontCustom(13);
        _ruleContentLabel.textAlignment=NSTextAlignmentLeft;
        _ruleContentLabel.numberOfLines = 0;
        _ruleContentLabel.textColor=kColorHex(@"#A3A3A3");
    }
    return _ruleContentLabel;
}

#pragma mark - Action

- (void)cashBtnAction{
    if (![self.textField.text isAmount]) {
        [self showMessage:@"请输入正确的金额" hideDelay:1];
        return;
    }
    
    
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi withdrawDepositUrl]
                              parameters:@{@"money":self.textField.text}
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                        [self showMessage:@"提现成功" hideDelay:1];
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     [self showMessage:kYbsRequestFailed hideDelay:1];
                                 }
     ];
    
}

#pragma mark - TextChanged

- (void)onTextChanged:(UITextField *)textField{
    if (textField.text.length > 0) {
        double money = [textField.text doubleValue];
        if (money > [self.balance doubleValue]) {
            [textField resignFirstResponder];
            [self showMessage:@"输入金额超过钱包金额" hideDelay:1.5];
            self.cashBtn.enabled = NO;
            self.cashBtn.alpha = 0.5;
        }else{
            
            if (money == 0) {
                self.cashBtn.enabled = NO;
                self.cashBtn.alpha = 0.5;
            }else{
                self.cashBtn.enabled = YES;
                self.cashBtn.alpha = 1;
            }
            
            
        }
        
    }else{
        self.cashBtn.enabled = NO;
        self.cashBtn.alpha = 0.5;
        
    }
}


/**
 *  textField的代理方法，监听textField的文字改变
 *  textField.text是当前输入字符之前的textField中的text
 *
 *  @param textField textField
 *  @param range     当前光标的位置
 *  @param string    当前输入的字符
 *
 *  @return 是否允许改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            [self.textField resignFirstResponder];
            [self showMessage:@"您的输入格式不正确" hideDelay:1];

            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            [self.textField resignFirstResponder];
            [self showMessage:@"最多只能输入一个小数点" hideDelay:1];
            
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    [self.textField resignFirstResponder];
                    [self showMessage:@"第二个字符需要是小数点" hideDelay:1];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    [self.textField resignFirstResponder];
                    [self showMessage:@"第二个字符需要是小数点" hideDelay:1];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    [self.textField resignFirstResponder];
                    [self showMessage:@"小数点后最多有两位小数" hideDelay:1];
                    
                    return NO;
                }
            }
        }
        
    }
    

    
    return YES;
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
