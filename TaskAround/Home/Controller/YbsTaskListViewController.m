//
//  YbsTaskListViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskListViewController.h"
#import "YbsTaskHomeCell.h"
#import "YbsLocationManager.h"
#import "YbsHomeViewController.h"
#import "YbsTaskDetailViewController.h"
#import "YbsTaskModel.h"
#import "UITableView+HD_NoList.h"

@interface YbsTaskListViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<YbsTaskModel *> *dataArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSNumber *order;
@property (nonatomic, assign) CLLocationCoordinate2D latestRequestCoordinate;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation YbsTaskListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isPlaceholderShown) {
        [self loadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildSubViews];
    self.page = 1;
}

- (void)buildSubViews{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    self.tableView.tableHeaderView = self.headerView;
    
    UIView *whiteBgView = [UIView new];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:whiteBgView];
    whiteBgView.layer.cornerRadius = 7;
    whiteBgView.layer.masksToBounds = YES;
    [whiteBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.headerView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    UIButton *searchIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchIcon setImage:kImageNamed(@"task_search") forState:UIControlStateNormal];
    [searchIcon addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:searchIcon];

    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(whiteBgView);
        make.left.equalTo(whiteBgView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(21.5, 21.5));
    }];
    
    self.searchTextField = [[UITextField alloc]init];
    self.searchTextField.delegate = self;
    self.searchTextField.font = kYbsFontCustom(15);
    self.searchTextField.textColor = kColorHex(@"#2F2F2F");
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSString *str = @"按地址搜索";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:kColorHex(@"#D2D2D2") range:NSMakeRange(0, str.length-1)];
    self.searchTextField.attributedPlaceholder = attributeStr;
    
    [self.headerView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(searchIcon);
        make.left.equalTo(searchIcon.mas_right).with.offset(15);
        make.right.equalTo(whiteBgView).with.offset(-15);
        make.height.equalTo(whiteBgView);
    }];
    
}

- (UITableView *)tableView{
    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 135;
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

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [UIView new];
        _headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _headerView.frame = CGRectMake(0, 0, kAppScreenWidth, 56);
    }
    return _headerView;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (void)searchAction{
    self.page = 1;
    [self loadData];
}

- (void)loadData{
    YbsHomeViewController *homeVC = (YbsHomeViewController *)self.parentViewController;
    
//    if (homeVC.mvc.mapView.centerCoordinate.latitude == self.latestRequestCoordinate.latitude && homeVC.mvc.mapView.centerCoordinate.longitude == self.latestRequestCoordinate.longitude) {
//        return;
//    }
    
    
    NSDictionary *parameterDic = @{
                                   @"longitude":[NSString stringWithFormat:@"%.6f",homeVC.mvc.mapView.centerCoordinate.longitude],
                                   @"latitude":[NSString stringWithFormat:@"%.6f",homeVC.mvc.mapView.centerCoordinate.latitude],
                                   @"keywords":self.searchTextField.text,
                                   @"pageNum":@(self.page),
                                   @"pageSize":@10
                                   };

    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:[YbsApi taskListUrl]
                              parameters:parameterDic
                                 success:^(id  _Nonnull responseObject) {
                                    @strongify(self);
                                    [SVProgressHUD dismiss];
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
                                            if (self.page > 1) {
                                                self.page--;
                                            }
                                        }
                                        [self.tableView reloadData];
                                        if (self.dataArray.count==0) {
//                                            [self.view showHudWithMessage:@"当前区域暂无任务"];
                                        }else{
                                            
                                        }
                                         [self resetNoDataView];
                                         
                                    }else{
                                        [self showMessage:dic[@"message"] hideDelay:1.0];
                                    }
                                     
                                 }
                                 failure:^(NSError * _Nonnull error) {
                                    @strongify(self);
                                    [SVProgressHUD dismiss];
                                    [self.tableView.mj_header endRefreshing];
                                    [self.tableView.mj_footer endRefreshing];
                                 }
     ];
    
    self.latestRequestCoordinate = homeVC.mvc.mapView.centerCoordinate;
    
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"HomeTaskCell";
    YbsTaskHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YbsTaskHomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    [cell setNeedsUpdateConstraints];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YbsTaskDetailViewController *vc = [[YbsTaskDetailViewController alloc]init];
    vc.taskModel = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self searchAction];
}


#pragma mark - nodata

- (void)resetNoDataView{
    if (self.dataArray.count>0) {
        [self.tableView dismissNoView];
        self.headerView.hidden = NO;
    }else{
        if (self.searchTextField.text && self.searchTextField.text.length > 0) {
            self.headerView.hidden = NO;
            [self.tableView showNoView:@"暂无匹配任务" image:kImageNamed(@"home_list_no_data") certer:CGPointZero];
        }else{
            self.headerView.hidden = YES;
            self.searchTextField.text = @"";
            [self.tableView showNoView:@"当前区域暂无任务" image:kImageNamed(@"home_list_no_data") certer:CGPointZero];
        }
        
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
