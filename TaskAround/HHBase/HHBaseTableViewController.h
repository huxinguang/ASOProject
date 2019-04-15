//
//  HHBaseTableViewController.h
//  BaseTabBar
//
//  Created by 豫风 on 2017/6/22.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HHBaseViewController.h"
#import "HHRefreshManager.h"


@interface HHBaseTableViewController : HHBaseViewController <HHRefreshManagerDelegate, UITableViewDelegate, UITableViewDataSource>

/******************************************

 非xib自动计算行高，需要重写 ---->"heightForRowAtIndexPath"
 详见属性"isXibAutomatic" at line 44
 
******************************************/

/**
 默认是一维数组，可重写数据源方法更改
 @warning: 如需要调用代理方法需要调用父类的实现
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 修改tableView的样式，默认plain
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/**
 "YES" xib自动计算行高,不做任何处理
 "NO" 重写方法<heightForRowAtIndexPath>并调用父类方法，有返回值直接使用，若不存在由子类计算行高。
 默认"NO"
 */
@property (nonatomic, assign) BOOL isXibAutomatic;

/**
 是否加载xib类型的cell，YES加载XIB类型，默认NO
 */
@property (nonatomic, assign) BOOL isLoadXibCell;

/**
 是否需要刷新，YES需要刷新，默认YES
 */
@property (nonatomic, assign) BOOL isNeedRefresh;

/**
 注册自定义的cellClass
 
 @param cellClass cell类
 */
- (void)registerCell:(Class)cellClass reuseIdentifier:(NSString *)identifier;

/**
 更新数据源刷新表格
 
 @param array 数据模型数组
 */
- (void)updateDataSource:(NSArray *)array;

/**
 进入视图自动刷新tableView
 */
- (void)automaticRefreshTableView;

/**
 由子类重写,开始刷新回调

 @param type 刷新类型头部或尾部
 */
- (void)beginRefreshWithType:(HHRefreshType)type;

/**
 结束刷新,由子类调用
 */
- (void)endRefreshWithType:(HHRefreshType)type;

/**
 加载更多数据完成，不显示加载视图
 */
- (void)loadMoreDataComplete;

@end
