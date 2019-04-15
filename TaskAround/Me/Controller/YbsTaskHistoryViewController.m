//
//  YbsTaskHistoryViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskHistoryViewController.h"
#import "YbsTaskHistoryCell.h"
#import "UITableView+HD_NoList.h"

@interface YbsTaskHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation YbsTaskHistoryViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (kUserDefaultGet(kYbsUserInfoDicKey)) {
        [self loadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"历史任务"];
    self.page = 1;
    [self buildSubViews];
}

- (void)buildSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 140;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        @weakify(self);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.page = 1;
            [self loadData];
        }];
        _tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            self.page++;
            [self loadData];
        }];
    }
    return _tableView;
}

- (void)loadData{
    NSDictionary *parameterDic = @{
                                   @"pageNum":@(self.page),
                                   @"pageSize":@10
                                   };
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi taskHistoryUrl]
                              parameters:parameterDic
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
                                         NSArray *arr = [NSArray modelArrayWithClass:[YbsTaskModel class] json:dic[kYbsDataKey][@"list"]];
                                         
                                         if (arr.count > 0) {
                                             [self.dataArray addObjectsFromArray:arr];
                                         }else{
                                             [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                             if (self.page>0) {
                                                 self.page--;
                                             }
                                         }
                                         [self.tableView reloadData];
                                         if (self.dataArray.count==0) {
//                                             [self.view showHudWithMessage:@"暂无历史任务"];
                                         }else{
                                             
                                         }
                                     }else{
                                         [self showMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"YbsTaskHistoryCell";
    YbsTaskHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YbsTaskHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    [cell setNeedsUpdateConstraints];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark - nodata

- (void)resetNoDataView{
    if (self.dataArray.count>0) {
        [self.tableView dismissNoView];
    }else{
        [self.tableView showNoView:@"暂无历史任务" image:kImageNamed(@"history_no_data") certer:CGPointZero];
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
