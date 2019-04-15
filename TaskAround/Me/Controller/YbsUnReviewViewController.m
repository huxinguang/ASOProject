//
//  YbsUnReviewViewController.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsUnReviewViewController.h"
#import "YbsTaskUnReviewCell.h"
#import "YbsAppealViewController.h"
#import "UITableView+HD_NoList.h"


@interface YbsUnReviewViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation YbsUnReviewViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.appearedNeedRefresh) {
        YbsUnReviewSubVC *leftVC = (YbsUnReviewSubVC *)self.listContainerView.validListDict[[NSNumber numberWithInteger:0]];
        YbsUnReviewSubVC *rightVC = (YbsUnReviewSubVC *)self.listContainerView.validListDict[[NSNumber numberWithInteger:1]];
        
//        YbsTaskModel *model = leftVC.dataArray[self.operateIndexPath.row];
        
        if (self.currentIndex == 1) {
            [rightVC.dataArray removeObjectAtIndex:self.operateIndexPath.row];
            [rightVC.tableView reloadData];
            [rightVC resetNoDataView];
        }
        
        leftVC.page = 1;
        [leftVC loadData];
        
        self.appearedNeedRefresh = NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    YbsNavTitleView *titleView = (YbsNavTitleView *)self.navigationItem.titleView;
    [titleView setTitleString:@"待审核"];
    self.titles = @[@"待审核", @"可申诉"];
    self.currentIndex = 0;
    [self buildSubViews];
}

- (void)buildSubViews{
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 43)];
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.delegate = self;
    self.categoryView.titleColor = kColorHex(@"#6D6D6D");
    self.categoryView.titleSelectedColor = kColorHex(@"#2F2F2F");
    [self.view addSubview:self.categoryView];
    self.categoryView.titles = self.titles;
    self.categoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = kColorHex(@"#FF2F29");
    lineView.indicatorLineWidth = 20;
    lineView.indicatorLineViewHeight = 1;
    self.categoryView.indicators = @[lineView];
    
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    self.listContainerView.defaultSelectedIndex = 0;
    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom);
        make.left.and.right.and.bottom.equalTo(self.view);
    }];
    
    self.categoryView.contentScrollView = self.listContainerView.scrollView;
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    [self.listContainerView didClickSelectedItemAtIndex:index];
    self.currentIndex = index;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index{
    [self.listContainerView didClickSelectedItemAtIndex:index];
    self.currentIndex = index;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.listContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    YbsUnReviewSubVC *vc = [[YbsUnReviewSubVC alloc]init];
    vc.type = index;
    return vc;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
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


@interface YbsUnReviewSubVC ()<UITableViewDelegate,UITableViewDataSource>



@end

@implementation YbsUnReviewSubVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (kUserDefaultGet(kYbsUserInfoDicKey)) {
        [self loadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    
    NSString *urlStr = nil;
    if (self.type == UnReviewSubVcLeft) {
        urlStr = [YbsApi taskUnReviewUrl];
    }else{
        urlStr = [YbsApi taskUnAppealUrl];
    }
    
    [SVProgressHUD show];
    @weakify(self);
    [[YbsNetworkUtil shareInstance] POST:urlStr
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
    static NSString *identifier = @"TaskUnReviewCell";
    YbsTaskUnReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YbsTaskUnReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    if (self.type == UnReviewSubVcLeft) {
        cell.cellType = CellTypeUnReview;
    }else{
        cell.cellType = CellTypeUnAppeal;
        [cell.appealBtn addTarget:self action:@selector(appealBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.appealBtn.tag = indexPath.row;
    }
    [cell setNeedsUpdateConstraints];
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView{
    return self.view;
}



#pragma mark - action

- (void)appealBtnAction:(UIButton *)sender{
    self.operateIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    
    YbsTaskModel *model = self.dataArray[sender.tag];
    YbsAppealViewController *vc = [[YbsAppealViewController alloc]init];
    vc.paperId = model.paperId;
//    [self.navigationController pushViewController:vc animated:YES];
    [[UIViewController currentViewController].navigationController pushViewController:vc animated:YES];
}


#pragma mark - nodata

- (void)resetNoDataView{
    if (self.dataArray.count>0) {
        [self.tableView dismissNoView];
    }else{
        if (self.type == UnReviewSubVcLeft) {
            [self.tableView showNoView:@"暂无待审核任务" image:kImageNamed(@"review_no_data") certer:CGPointZero];
        }else{
            [self.tableView showNoView:@"暂无可申诉任务" image:kImageNamed(@"appeal_no_data") certer:CGPointZero];
        }
        
    }
}





@end




