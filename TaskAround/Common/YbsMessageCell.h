//
//  YbsMessageCell.h
//  TaskAround
//
//  Created by xinguang hu on 2019/4/11.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YbsMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YbsMessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *dotView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) YbsMessageModel *model;

@end

NS_ASSUME_NONNULL_END
