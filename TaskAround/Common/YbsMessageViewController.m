//
//  YbsMessageViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/4/1.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsMessageViewController.h"
#import "YbsMessageCell.h"
#import "UITableView+HD_NoList.h"
#import "YbsMessageDetailVC.h"
#import "YbsWebViewController.h"


@interface YbsMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@end

@implementation YbsMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"我的消息"];
    self.page = 1;
    [self buildSubViews];
    [self loadData];
    
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
        _tableView.rowHeight = 50;
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
    [MBProgressHUD showLoadingInView];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi messageListUrl]
                              parameters:parameterDic
                                 success:^(id  _Nonnull responseObject) {
                                     [MBProgressHUD hideHUD];
                                     @strongify(self);
                                     [self.tableView.mj_header endRefreshing];
                                     [self.tableView.mj_footer endRefreshing];
                                     NSDictionary *dic = responseObject;
                                     if ([dic[kYbsCodeKey] isEqualToString:kYbsSuccess]) {
                                         if (self.page==1) {
                                             [self.dataArray removeAllObjects];
                                         }
                                         NSArray *arr = [NSArray modelArrayWithClass:[YbsMessageModel class] json:dic[kYbsDataKey][@"data"]];
                                         
                                         if (arr.count > 0) {
                                             [self.dataArray addObjectsFromArray:arr];
                                         }else{
                                             [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                             if (self.page>0) {
                                                 self.page--;
                                             }
                                         }
                                         [self.tableView reloadData];
                                         
                                     }else{
                                         [MBProgressHUD showTipInViewWithMessage:dic[kYbsMsgKey] hideDelay:1.0];
                                     }
                                     
                                     [self resetNoDataView];
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                     @strongify(self);
                                     [MBProgressHUD hideHUD];
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
    static NSString *identifier = @"YbsMessageCell";
    YbsMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YbsMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    [cell setNeedsUpdateConstraints];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YbsMessageModel *model = self.dataArray[indexPath.row];
//    if ([model.openType isEqualToString:@"1"]) {//1进入连接
//        YbsWebViewController *wvc = [[YbsWebViewController alloc]init];
//        wvc.pageTitle = @"消息详情";
//        wvc.pageUrl = model.openUrl;
//        [self.navigationController pushViewController:wvc animated:YES];
//    }else{// 2进入详情页
        YbsMessageDetailVC *vc = [[YbsMessageDetailVC alloc]init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
//    }
    
}


#pragma mark - nodata

- (void)resetNoDataView{
    if (self.dataArray.count>0) {
        [self.tableView dismissNoView];
    }else{
        [self.tableView showNoView:@"暂无消息" image:kImageNamed(@"history_no_data") certer:CGPointZero];
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
