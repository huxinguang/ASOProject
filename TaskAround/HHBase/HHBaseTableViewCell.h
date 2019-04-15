//
//  HHBaseTableViewCell.h
//  BaseTabBar
//
//  Created by 豫风 on 2017/6/21.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIView+HHConstruct.h"

@interface HHBaseTableViewCell : UITableViewCell

@property (nonatomic, weak) id delegate;//cell代理对象

/**
 纯代码cell的初始化方法

 @param delegate cell代理对象
 @param tableView 父控件tableView
 @param identifier cell重用ID
 @param indexPath 索引
 @param listArray 数据源模型
 @param isSure 是否更新数据
 @return self
 */
+ (instancetype)cellWithDelegate:(id)delegate TableView:(UITableView *)tableView reuserIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath titleListArray:(NSArray *)listArray needSetData:(BOOL)isSure;

/**
 xib类型的cell的初始化方法
 */
+ (instancetype)xibCellWithDelegate:(id)delegate TableView:(UITableView *)tableView reuserIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath titleListArray:(NSArray *)listArray needSetData:(BOOL)isSure;

/**
 子类重写为cell赋值

 @param tableView cell父控件
 @param indexPath 索引
 @param listArray 数据源模型
 @return self
 */
- (instancetype)setCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath andArray:(NSArray *)listArray needSetData:(BOOL)isSure;

/**
 由子类重写
 加载基本配置信息
 */
- (void)configInitialInfo;
- (void)configBaseInfo;


@end
