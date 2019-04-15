//
//  YbsMeViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/25.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsMeViewController.h"
#import "YbsProfileButton.h"
#import "YbsPersonalInfoController.h"
#import "YbsUnCommitViewController.h"
#import "YbsUnReviewViewController.h"
#import "YbsTaskHistoryViewController.h"
#import "YbsWalletViewController.h"
#import "YbsSettingViewController.h"
#import "YbsWebViewController.h"
#import "YbsLoginViewController.h"
#import "YbsNavigationController.h"
#import "TestViewController.h"

#define kYbsAvatarBtnHW 85.0*(kAppScreenWidth/375)

@interface YbsMeViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, strong) UIView *whiteBgView1;
@property (nonatomic, strong) UIView *whiteBgView2;
@property (nonatomic, strong) YbsProfileButton *moneyBtn;

@end

@implementation YbsMeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    NSDictionary *dic = kUserDefaultGet(kYbsUserInfoDicKey);
    if (dic) {
        [self loadData];
        if (dic[@"nickName"]) {
            [self.nameBtn setTitle:dic[@"nickName"] forState:UIControlStateNormal];
        }else{
            [self.nameBtn setTitle:@"暂无昵称" forState:UIControlStateNormal];
        }
        self.moneyBtn.subTitleLab.hidden = NO;
    }else{
        [self.nameBtn setTitle:@"去登录>>" forState:UIControlStateNormal];
        self.moneyBtn.subTitleLab.hidden = YES;
    }
    
    [self.avatarBtn setImageWithURL:[NSURL URLWithString:dic[@"headImg"]] forState:UIControlStateNormal placeholder:kImageNamed(@"profile_avatar")];
    
}

- (void)configLeftBarButtonItem{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate= self;
    [self buildSubViews];
}

- (void)buildSubViews{
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.avatarBtn];
    [self.view addSubview:self.nameBtn];
    [self.view addSubview:self.whiteBgView1];
    NSArray *topTitles = @[@"待提交",@"待审核"];
    NSArray *topImages = @[@"profile_uncommit",@"profile_unreview"];
    for (int i=0; i<topTitles.count; i++) {
        YbsProfileButton *btn = [[YbsProfileButton alloc]init];
        btn.frame = CGRectMake(self.whiteBgView1.width/3*i, 0, self.whiteBgView1.width/3, self.whiteBgView1.height);
        btn.tag = i;
        btn.subTitleLab.hidden = YES;
        btn.title = topTitles[i];
        btn.font = kYbsFontCustom(15);
        btn.image = kImageNamed(topImages[i]);
        [btn addTarget:self action:@selector(btnAction:)];
        [self.whiteBgView1 addSubview:btn];
    }
    
    [self.view addSubview:self.whiteBgView2];
    
    NSArray *bottomTitles = @[@"历史任务",@"我的钱包",@"新手指南",@"设置"];
    NSArray *bottomImages = @[@"profile_history",@"profile_wallet",@"profile_guide",@"profile_setting"];
    CGFloat marginTop = 15;
    CGFloat marginBottom = 15;
    CGFloat itemW = self.whiteBgView2.width/3;
    CGFloat itemH = (self.whiteBgView2.height - marginTop - marginBottom)/2;
    
    for (int i=0; i<bottomTitles.count; i++) {
        YbsProfileButton *btn = [[YbsProfileButton alloc]init];
        btn.frame = CGRectMake((i%3)*itemW, marginTop + (i/3)*itemH, itemW, itemH);
        btn.tag = i+topTitles.count;
        btn.title = bottomTitles[i];
        btn.font = kYbsFontCustom(15);
        btn.image = kImageNamed(bottomImages[i]);;
        [btn addTarget:self action:@selector(btnAction:)];
        [self.whiteBgView2 addSubview:btn];
        if (i==1) {
            btn.subTitleLab.hidden = NO;
            self.moneyBtn = btn;
        }else{
            btn.subTitleLab.hidden = YES;
        }
        
    }
    
    
}

- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        _topImageView.image = kImageNamed(@"profile_top_bg");
        _topImageView.frame = CGRectMake(0, 0, kAppScreenWidth, kAppScreenWidth*230.0/375.0);
    }
    return _topImageView;
}

- (UIButton *)avatarBtn{
    if (!_avatarBtn) {
        _avatarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarBtn.frame = CGRectMake(kAppScreenWidth/2-kYbsAvatarBtnHW/2, 80*kAppScreenHeight/1334, kYbsAvatarBtnHW, kYbsAvatarBtnHW);
        _avatarBtn.layer.cornerRadius = kYbsAvatarBtnHW/2;
        _avatarBtn.layer.masksToBounds = YES;
        _avatarBtn.layer.borderWidth = 4;
        _avatarBtn.layer.borderColor = kColorHex(@"#EC211B").CGColor;
        [_avatarBtn addTarget:self action:@selector(avatarClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarBtn;
}

- (UIButton *)nameBtn{
    if (!_nameBtn) {
        _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nameBtn.frame = CGRectMake(50, self.avatarBtn.bottom + 10, kAppScreenWidth-50*2, 25);
        [_nameBtn setTitle:@"请设置昵称" forState:UIControlStateNormal];
        _nameBtn.titleLabel.font = kYbsFontCustomBold(17);
        [_nameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nameBtn addTarget:self action:@selector(nameClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nameBtn;
}

- (UIView *)whiteBgView1{
    if (!_whiteBgView1) {
        _whiteBgView1 = [UIView new];
        _whiteBgView1.frame = CGRectMake(10, self.topImageView.bottom + 10, kAppScreenWidth-2*10, (kAppScreenWidth-2*10)*90/355);
        _whiteBgView1.backgroundColor = [UIColor whiteColor];
        _whiteBgView1.layer.cornerRadius = 10*kAppScreenWidth/375;
        _whiteBgView1.layer.masksToBounds = YES;
        
    }
    return _whiteBgView1;
}

- (UIView *)whiteBgView2{
    if (!_whiteBgView2) {
        _whiteBgView2 = [UIView new];
        _whiteBgView2.frame = CGRectMake(10, self.whiteBgView1.bottom + 10, kAppScreenWidth-2*10, (kAppScreenWidth-2*10)*225/355);
        _whiteBgView2.backgroundColor = [UIColor whiteColor];
        _whiteBgView2.layer.cornerRadius = 10*kAppScreenWidth/375;
        _whiteBgView2.layer.masksToBounds = YES;
    }
    return _whiteBgView2;
}


#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}


#pragma mark - Action

- (void)avatarClick{
    if (![self ifLogin]) {
        return;
    }
    YbsPersonalInfoController *vc = [[YbsPersonalInfoController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    TestViewController *vc = [[TestViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)nameClick{
    if (![self ifLogin]) {
        return;
    }
}

- (void)btnAction:(YbsProfileButton *)sender{
    if (![self ifLogin]) {
        return;
    }
    
    switch (sender.tag) {
        case 0:
        {
            YbsUnCommitViewController *vc = [[YbsUnCommitViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            YbsUnReviewViewController *vc = [[YbsUnReviewViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            YbsTaskHistoryViewController *vc = [[YbsTaskHistoryViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            YbsWalletViewController *vc = [[YbsWalletViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            YbsWebViewController *wvc = [[YbsWebViewController alloc]init];
            wvc.pageTitle = @"新手指南";
            wvc.pageUrl = [YbsApi howToUseUrl];
            [self.navigationController pushViewController:wvc animated:YES];
        }
            break;
        case 5:
        {
            YbsSettingViewController *vc = [[YbsSettingViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)ifLogin{
    if (!kUserDefaultGet(kYbsUserInfoDicKey)) {
        YbsLoginViewController *vc = [[YbsLoginViewController alloc]init];
        __weak typeof (vc) weakVC = vc;
        vc.successBlock = ^ {
            [weakVC dismissViewControllerAnimated:YES completion:^{
            }];
        };
        
        vc.visitorBlock = ^{
            [weakVC dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
        UINavigationController *nav = [[YbsNavigationController alloc] initWithRootViewController:vc];
        
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }else{
        return YES;
    }
    
}


#pragma mark - data

- (void)loadData{
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi walletBalanceUrl]
                              parameters:@{}
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                         self.moneyBtn.subTitleLab.text = [NSString stringWithFormat:@"￥%@",dic[kYbsDataKey][@"balance"]];
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [self showMessage:kYbsRequestFailed hideDelay:1];
                                 }
     ];
    
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
