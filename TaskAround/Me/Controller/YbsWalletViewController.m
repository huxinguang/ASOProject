//
//  YbsWalletViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsWalletViewController.h"
#import "YbsMoneyDetailCell.h"
#import "YbsCashViewController.h"
#import "YbsMoneyDetailModel.h"
#import "YbsAlertView.h"
#import "UITableView+HD_NoList.h"
#import "NSDictionary+YbsObject.h"

#define YbsWalletHeaderHeight 260*kAppScreenWidth/375

@interface YbsWalletViewController ()<UITableViewDataSource,UITableViewDelegate,YbsAlertViewDelegate>

@property (nonatomic, strong) UILabel *balanceLabel;
//@property (nonatomic, strong) UILabel *moneyIconLabel;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *unGivenLabel;
@property (nonatomic, strong) UIButton *cashBtn;
@property (nonatomic, strong) UIView *grayBgView;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) NSDictionary *topDataDic;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YbsWalletViewController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (kUserDefaultGet(kYbsUserInfoDicKey)) {
        [self loadTopData];
        [self loadBottomData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorHex(@"#EFEFEF");
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"我的钱包"];
    [self buildSubViews];
    [self addConstraints];
    [self.view layoutIfNeeded];
    self.page = 1;
//    [self.view setNeedsUpdateConstraints];
    
    
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (void)buildSubViews{
    [self.view addSubview:self.headerView];
    [self.headerView addSubview:self.balanceLabel];
    [self.headerView addSubview:self.moneyLabel];
    [self.headerView addSubview:self.unGivenLabel];

    [self.headerView addSubview:self.cashBtn];
    self.cashBtn.layer.cornerRadius = 3;
    self.cashBtn.layer.masksToBounds = YES;
    [self.headerView addSubview:self.grayBgView];
    [self.headerView addSubview:self.detailLabel];
    
    [self.view addSubview:self.tableView];

}

- (void)addConstraints{
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self.view);
        make.height.mas_equalTo(YbsWalletHeaderHeight);
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).with.offset(10);
        make.left.equalTo(self.headerView).with.offset(17);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(self.headerView).with.offset(37*kAppScreenWidth/375);
    }];
    
//    [self.moneyIconLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.moneyLabel.mas_left).with.offset(-3);
//        make.centerY.equalTo(self.moneyLabel);
//    }];
    
    [self.unGivenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).with.offset(15*kAppScreenWidth/375);
        make.centerX.equalTo(self.headerView);
    }];
    
    [self.cashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(self.unGivenLabel.mas_bottom).with.offset(20*kAppScreenWidth/375);
        make.size.mas_equalTo(CGSizeMake(138*kAppScreenWidth/375, 40*kAppScreenWidth/375));
    }];
    
    [self.grayBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.headerView);
        make.bottom.equalTo(self.headerView);
        make.height.mas_equalTo(40*kAppScreenWidth/375);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.balanceLabel);
        make.bottom.equalTo(self.grayBgView).with.offset(-5);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.and.bottom.and.right.equalTo(self.view);
    }];
    
}


- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UILabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel=[[UILabel alloc] init];
        _balanceLabel.text = @"钱包余额";
        _balanceLabel.font=kYbsFontCustom(14);
        _balanceLabel.textAlignment=NSTextAlignmentLeft;
        _balanceLabel.textColor=kColorHex(@"#2F2F2F");
    }
    return _balanceLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel=[[UILabel alloc] init];
        _moneyLabel.text = @"";
        _moneyLabel.textAlignment=NSTextAlignmentCenter;
        _moneyLabel.textColor=kColorHex(@"#2F2F2F");
    }
    return _moneyLabel;
}


- (UILabel *)unGivenLabel{
    if (!_unGivenLabel) {
        _unGivenLabel=[[UILabel alloc] init];
        _unGivenLabel.text = @"待发放：";
        _unGivenLabel.font=kYbsFontCustom(13);
        _unGivenLabel.textAlignment=NSTextAlignmentRight;
        _unGivenLabel.textColor=kColorHex(@"#ABABAB");
    }
    return _unGivenLabel;
}

- (UIButton *)cashBtn{
    if (!_cashBtn) {
        _cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cashBtn.backgroundColor = kColorHex(@"#FF2F29");
        [_cashBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_cashBtn addTarget:self action:@selector(cashBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cashBtn;
}

- (UIView *)grayBgView{
    if(!_grayBgView){
        _grayBgView = [[UIView alloc] init];
        _grayBgView.backgroundColor = kColorHex(@"#EFEFEF");
    }
    return _grayBgView;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel=[[UILabel alloc] init];
        _detailLabel.text = @"余额明细";
        _detailLabel.font = kYbsFontCustom(14);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _detailLabel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 50*kYbsRatio;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadTopData];
        }];
        _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page++;
            [self loadBottomData];
        }];
    }
    return _tableView;
}


- (void)cashBtnAction{

    [self checkIfFollowWechat];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellID";
    YbsMoneyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YbsMoneyDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//
//    return self.headerView;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return YbsWalletHeaderHeight;
//}


#pragma mark - YbsAlertViewDelegate

- (void)didClickClose{
    
}

- (void)didClickBtnOne{
    [self showMessageToWindow:@"已复制到剪贴板" hideDelay:1.5];
}

- (void)didClickBtnTwo{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpen){
        [[UIApplication sharedApplication] openURL:url];
    }else{
        [self showMessageToWindow:@"请先安装微信" hideDelay:1.5];
    }
}




#pragma mark - data

- (void)loadTopData{

    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi walletBalanceUrl]
                              parameters:@{}
                                 success:^(id  _Nonnull responseObject) {
                                     @strongify(self);
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                         NSDictionary *dataDic = dic[kYbsDataKey];
                                         self.topDataDic = [dataDic convertNullValueToEmptyStr];
                                         NSString *str = [NSString stringWithFormat:@"￥%@",self.topDataDic[@"balance"]];
                                         NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
                                         [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(5*kYbsRatio) range:NSMakeRange(0,1)];
                                         [attributedString addAttribute:NSFontAttributeName value:kYbsFontCustomBold(32) range:NSMakeRange(0,1)];
                                         [attributedString addAttribute:NSFontAttributeName value:kYbsFontCustomBold(46) range:NSMakeRange(1,str.length-1)];
                                         self.moneyLabel.attributedText = attributedString;
                                         self.unGivenLabel.text = [NSString stringWithFormat:@"待发放：%@",self.topDataDic[@"waitMoney"]];
                                         
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                 }
     ];
    
}


- (void)loadBottomData{
    
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi balanceDetailUrl]
                              parameters:@{@"pageNum":@(self.page),
                                           @"pageSize":@10
                                           }
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                         if (self.page==1) {
                                             [self.dataArray removeAllObjects];
                                         }
                                         NSArray *arr = [NSArray modelArrayWithClass:[YbsMoneyDetailModel class] json:dic[kYbsDataKey][@"list"]];
                                         if (arr.count > 0) {
                                             [self.dataArray addObjectsFromArray:arr];
                                         }else{
                                             [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                             if (self.page>0) {
                                                 self.page--;
                                             }
                                         }
                                         
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                     [self.tableView reloadData];
                                     [self resetNoDataView];
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [SVProgressHUD dismiss];
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                 }
     ];
    
}

- (void)checkIfFollowWechat{
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi ifFollowWechatUrl]
                              parameters:@{}
                                 success:^(id  _Nonnull responseObject) {
                                     [SVProgressHUD dismiss];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                         NSDictionary *dd = dic[kYbsDataKey];
                                         NSDictionary *dataDic = [dd convertNullValueToEmptyStr];
                                        
                                         if ([dataDic[@"isFollow"] isEqualToString:@"1"]) {
                                             YbsCashViewController *vc = [[YbsCashViewController alloc]init];
                                             vc.balance = self.topDataDic[@"balance"];
                                             vc.wechatNickname = dataDic[@"nickName"];
                                             vc.ruleContent = self.topDataDic[@"content"];
                                             
                                             [self.navigationController pushViewController:vc animated:YES];
                                         }else{
                                             YbsAlertView *alert = [[YbsAlertView alloc]initWithType:AlertViewTypeWechat delegate:self];
                                             [alert show];
                                         }
                                         
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


#pragma mark - nodata




- (void)resetNoDataView{
    if (self.dataArray.count>0) {
        [self.tableView dismissNoView];
    }else{
        [self.tableView showNoView:@"暂无明细" image:kImageNamed(@"wallet_no_data") certer:CGPointZero];
    }
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
