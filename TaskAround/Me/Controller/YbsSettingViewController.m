//
//  YbsSettingViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsSettingViewController.h"
#import "YbsSettingCell.h"
#import "YbsAboutUsViewController.h"
#import "YbsAwardView.h"

@interface YbsSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *exitBtn;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation YbsSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"设置"];
    
    self.dataArray = @[@"关于我们"];
    [self buildSubViews];
    [self addConstraints];
}

- (void)buildSubViews{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.exitBtn];
    [self.view addSubview:self.versionLabel];
    self.exitBtn.layer.cornerRadius = 3;
    self.exitBtn.layer.masksToBounds = YES;
}

- (void)addConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-150);
    }];
    
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-88);
        make.left.equalTo(self.view).with.offset(50);
        make.right.equalTo(self.view).with.offset(-50);
        make.height.mas_equalTo(40);
    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-14-kAppTabbarSafeBottomMargin);
    }];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 57;
    }
    return _tableView;
}

- (UIButton *)exitBtn{
    if (!_exitBtn) {
        _exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exitBtn.backgroundColor = kColorHex(@"#FF2F29");
        [_exitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitBtn addTarget:self action:@selector(exitBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitBtn;
}

- (UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel=[[UILabel alloc] init];
        _versionLabel.text = @"当前版本号 1.0.0";
        _versionLabel.font = kYbsFontCustom(15);
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        _versionLabel.textColor = kColorHex(@"#999999");
    }
    return _versionLabel;
}


#pragma mark - Action

- (void)exitBtnAction{
    
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi logoutUrl]
                              parameters:@{}
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]){
                                         kUserDefaultRemove(kYbsUserInfoDicKey);
                                         kUserDefaultSynchronize;
                                         [self showMessage:@"退出成功" hideDelay:1 complete:^{
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
                                         
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


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellID";
    YbsSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YbsSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YbsAboutUsViewController *vc = [[YbsAboutUsViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    YbsAwardView *aView = [[YbsAwardView alloc]initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight)];
//    [[UIApplication sharedApplication].keyWindow addSubview:aView];
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
