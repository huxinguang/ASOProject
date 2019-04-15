//
//  YbsTaskBaseCell.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/27.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YbsTaskModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YbsTaskBaseCell : UITableViewCell

@property (nonatomic, strong) YbsTaskModel *model;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *taskLeftImgView;
@property (nonatomic, strong) UILabel *taskNameLabel;
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *shopNameLabel;

- (void)buildSubViews;
- (void)setModel:(YbsTaskModel *)model;
- (NSString *)formattedDistance:(NSInteger)meters;


@end

NS_ASSUME_NONNULL_END
