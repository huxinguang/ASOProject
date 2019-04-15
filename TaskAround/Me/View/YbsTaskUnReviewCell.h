//
//  YbsTaskUnReviewCell.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/7.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,CellType) {
    CellTypeUnReview,
    CellTypeUnAppeal
    
};

@interface YbsTaskUnReviewCell : YbsTaskBaseCell

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIButton *appealBtn;
@property (nonatomic, assign) CellType cellType;

@end

NS_ASSUME_NONNULL_END
