//
//  YbsMoneyDetailCell.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YbsMoneyDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YbsMoneyDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftTopLabel;
@property (nonatomic, strong) UILabel *leftBottomLabel;
@property (nonatomic, strong) UILabel *rightTopLabel;
@property (nonatomic, strong) UILabel *rightBottomLabel;
@property (nonatomic, strong) UIView  *lineView;
@property (nonatomic, strong) YbsMoneyDetailModel *model;


@end



NS_ASSUME_NONNULL_END
