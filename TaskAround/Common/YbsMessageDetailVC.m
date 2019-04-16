//
//  YbsMessageDetailVC.m
//  TaskAround
//
//  Created by xinguang hu on 2019/4/15.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsMessageDetailVC.h"

@interface YbsMessageDetailVC ()

@property (nonatomic, copy  ) UILabel *authorLabel;
@property (nonatomic, copy  ) UILabel *contentLabel;
@property (nonatomic, copy  ) UILabel *timeLabel;
@property (nonatomic, strong) YbsMessageModel *detailModel;

@end

@implementation YbsMessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"消息内容"];
    
    [self.view addSubview:self.authorLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.timeLabel];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.view).with.offset(10);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.authorLabel.mas_bottom).with.offset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.top.equalTo(self.timeLabel.mas_bottom).with.offset(10);
    }];
    
    [self loadData];
    
}

- (UILabel *)authorLabel{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.text = self.model.content;
        _authorLabel.font = kYbsFontCustom(17);
        _authorLabel.textColor = kColorHex(@"#2F2F2F");
        _authorLabel.text = @"发件人：管理员";
    }
    return _authorLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = self.model.content;
        _contentLabel.font = kYbsFontCustom(15);
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _contentLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kYbsFontCustom(15);
        _timeLabel.textColor = kColorHex(@"#2F2F2F");
        _timeLabel.text = [NSString stringWithFormat:@"时间：%@",self.model.createTime];
    }
    return _timeLabel;
}

- (void)loadData{
    NSDictionary *parameterDic = @{
                                   @"messageId":self.model.msgId
                                   };
    [MBProgressHUD showLoadingInView];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi messageDetailUrl]
                              parameters:parameterDic
                                 success:^(id  _Nonnull responseObject) {
                                     [MBProgressHUD hideHUD];
                                     @strongify(self);
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                         self.model.hasRead = @"1";
                                         
                                         self.detailModel = [YbsMessageModel modelWithJSON:dic[kYbsDataKey]];
                                         self.contentLabel.text = self.detailModel.content;
                                     }else{
                                         [MBProgressHUD showTipInViewWithMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                    
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     [MBProgressHUD hideHUD];
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
