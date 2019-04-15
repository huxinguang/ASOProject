//
//  HHBaseTableViewController.m
//  BaseTabBar
//
//  Created by 豫风 on 2017/6/22.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "HHBaseTableViewController.h"
#import "HHBaseTableViewCell.h"
#import "UIView+HHLayout.h"
#import "HHRefreshManager.h"


typedef NS_ENUM(NSUInteger, ScrollDirection) {
    ScrollDirectionNone,
    ScrollDirectionUp,
    ScrollDirectionDown,
};

#define IndexPathKey [NSString stringWithFormat:@"%ldG%ldH",(long)indexPath.section, (long)indexPath.row]


@interface HHBaseTableViewController ()

@property (nonatomic, strong) NSMutableDictionary *rowHeightDict;
@property (nonatomic, strong) HHRefreshManager *refreshManager;//刷新管理对象
@property (nonatomic, copy)   NSString *cellIdentifier;//cell重用ID
@property (nonatomic, copy)   NSArray *dataArray;//数据源数组
@property (nonatomic, strong) Class  cellClass;//cell 类名
@property (nonatomic, assign) BOOL isDragView;
@property (nonatomic, assign) BOOL isNeedSetData;
@property (nonatomic, assign) ScrollDirection scrollDirection;

@end


@implementation HHBaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseTableViewInitialInfo];
}

- (void)configBaseTableViewInitialInfo
{
    self.rowHeightDict = [NSMutableDictionary dictionary];
    self.tableView = [[UITableView alloc] initWithFrame:self.bgView.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    [self.bgView addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.refreshManager = [HHRefreshManager refreshWithDelegate:self scrollView:self.tableView];
    self.tableView.around_();
    self.tableView.bott_.constant(-kAppTabbarSafeBottomMargin).on_();
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 0.0f;
    self.isXibAutomatic = NO;
    self.isNeedSetData = YES;
    self.isLoadXibCell = NO;
}

- (void)registerCell:(Class)cellClass reuseIdentifier:(NSString *)identifier
{
    self.cellClass = cellClass;
    self.cellIdentifier = identifier;
}

- (void)updateDataSource:(NSArray *)array
{
    self.dataArray = array;
    if (!self.dataArray.count)return;
    [self.tableView reloadData];
}

- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle
{
    if (tableViewStyle == self.tableView.style) {
        return;
    }
    [self destroyInitailInfo];
    [self configTableViewWithStyle:tableViewStyle];
}
- (void)destroyInitailInfo
{
    [self.refreshManager removeInitialSubviews];
    self.refreshManager = nil;
    [self.tableView removeFromSuperview];
    self.tableView = nil;
}
- (void)configTableViewWithStyle:(UITableViewStyle)style
{
    self.tableView = [[UITableView alloc] initWithFrame:self.bgView.bounds style:style];
    [self.bgView addSubview:self.tableView];
    self.tableView.around_();
    if (self.isNeedRefresh) {

        self.refreshManager = [HHRefreshManager refreshWithDelegate:self scrollView:self.tableView];
    }
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}
- (void)setIsNeedRefresh:(BOOL)isNeedRefresh
{
    _isNeedRefresh = isNeedRefresh;
    if (!isNeedRefresh) {
        
        [self.refreshManager removeInitialSubviews];
        self.refreshManager = nil;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLoadXibCell) {
        
        return [self.cellClass xibCellWithDelegate:self TableView:tableView reuserIdentifier:self.cellIdentifier indexPath:indexPath titleListArray:self.dataArray needSetData:self.isNeedSetData];
    }else
    {
        return [self.cellClass cellWithDelegate:self TableView:tableView reuserIdentifier:self.cellIdentifier indexPath:indexPath titleListArray:self.dataArray needSetData:self.isNeedSetData];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.rowHeight) {
        return tableView.rowHeight;
    }
    NSNumber *rowHeight = [self.rowHeightDict objectForKey:IndexPathKey];
    if (self.isLoadXibCell && self.isXibAutomatic) {
        return rowHeight ? rowHeight.floatValue : UITableViewAutomaticDimension;
    }
    return rowHeight ? rowHeight.floatValue : 0;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.rowHeightDict setObject:[NSNumber numberWithFloat:cell.frame.size.height] forKey:IndexPathKey];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.isDragView) {
        CGPoint velocity = [scrollView.panGestureRecognizer velocityInView:self.tableView];
        if (velocity.y > 0) {
            self.scrollDirection = ScrollDirectionDown;
            self.isDragView = YES;
        }else if (velocity.y <0)
        {
            self.scrollDirection = ScrollDirectionUp;
            self.isDragView = YES;
        }else
        {
            self.isDragView = NO;
            self.refreshManager.isNeedRefresh = NO;
        }
        if (self.scrollDirection == ScrollDirectionDown && scrollView.contentOffset.y<=0) {
            self.refreshManager.isNeedRefresh = YES;
        }
        if (self.scrollDirection == ScrollDirectionUp && scrollView.contentSize.height-60<=scrollView.contentOffset.y+scrollView.frame.size.height) {
            self.refreshManager.isNeedRefresh = YES;
        }
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDragView = YES;
    self.refreshManager.isNeedRefresh = NO;
}

- (void)automaticRefreshTableView
{
    [self.tableView setContentOffset:CGPointMake(0, -70) animated:YES];
}
- (void)loadMoreDataComplete
{
    self.refreshManager.isNeedFootRefresh = NO;
}
- (void)endRefreshWithType:(HHRefreshType)type
{
    [self.refreshManager endRefreshWithType:type];
}

- (void)beginRefreshWithType:(HHRefreshType)type{//need to override
    
}
- (void)doubleClickActionNeedToDo
{
    if (self.scrollDirection == ScrollDirectionUp) {
        
        self.scrollDirection = ScrollDirectionNone;
        if ((int)(self.tableView.contentOffset.y) == (int)(self.tableView.contentSize.height-self.tableView.height)) {
            
            [self.tableView setContentOffset:CGPointZero animated:YES];
        }else
        {
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.height) animated:YES];
        }
        
    }else if (self.scrollDirection == ScrollDirectionDown)
    {
        self.scrollDirection = ScrollDirectionNone;
        if (CGPointEqualToPoint(self.tableView.contentOffset, CGPointZero)) {
            
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.height) animated:YES];
        }else
        {
            [self.tableView setContentOffset:CGPointZero animated:YES];
        }
    }else
    {
        if (CGPointEqualToPoint(self.tableView.contentOffset, CGPointZero)) {
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.height) animated:YES];
        }else
        {
            [self.tableView setContentOffset:CGPointZero animated:YES];
        }
    }
}

- (void)showNavBar:(BOOL)isShow animation:(BOOL)animate
{
    [super showNavBar:isShow animation:animate];
    
    if (animate) {
        
        if (isShow) {
            
            self.tableView.hh_topCS.constant = 0;
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.view layoutIfNeeded];
            }];
            
        }else
        {
            self.tableView.hh_topCS.constant = 20;
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.view layoutIfNeeded];
            }];
        }
    }else
    {
        if (isShow) {
            
            self.tableView.hh_topCS.constant = 0;
        }else
        {
            self.tableView.hh_topCS.constant = 20;
        }
    }
}


@end
