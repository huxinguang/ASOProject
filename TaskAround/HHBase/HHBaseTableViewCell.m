//
//  HHBaseTableViewCell.m
//  BaseTabBar
//
//  Created by 豫风 on 2017/6/21.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "HHBaseTableViewCell.h"

@implementation HHBaseTableViewCell

+ (instancetype)cellWithDelegate:(id)delegate TableView:(UITableView *)tableView reuserIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath titleListArray:(NSArray *)listArray needSetData:(BOOL)isSure
{
    HHBaseTableViewCell * cell = nil;
    if (identifier && identifier.length != 0){
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setDelegate:delegate];
        }
    }
    else{
         cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setDelegate:delegate];
    }
    if (!cell) return nil;
    return [cell setCellWithTableView:tableView indexPath:indexPath andArray:listArray needSetData:isSure];
}

+ (instancetype)xibCellWithDelegate:(id)delegate TableView:(UITableView *)tableView reuserIdentifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath titleListArray:(NSMutableArray *)listArray needSetData:(BOOL)isSure
{
    HHBaseTableViewCell * cell = nil;
    if (identifier && identifier.length != 0){
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
            [cell setDelegate:delegate];
        }
    }
    else
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
        [cell setDelegate:delegate];
    }
    if (!cell) return nil;
    return [cell setCellWithTableView:tableView indexPath:indexPath andArray:listArray needSetData:isSure];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configInitialInfo];
        [self configBaseInfo];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configInitialInfo];
    [self configBaseInfo];
}

- (instancetype)setCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath andArray:(NSMutableArray *)listArray needSetData:(BOOL)isSure
{
    return self;
}

- (void)setDelegate:(id)delegate
{
    _delegate = delegate;
}

/********-----------------------------------------***********
 #pragma mark -供子类重写调用
 ********-----------------------------------------***********/
- (void)configInitialInfo{

    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)configBaseInfo{}


@end
