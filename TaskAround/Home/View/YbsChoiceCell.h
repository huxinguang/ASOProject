//
//  YbsChoiceCell.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/19.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsChoiceCell : UITableViewCell

@property (nonatomic, strong) UIImageView *checkBox;
@property (nonatomic, strong) UILabel *choiceLabel;

- (void)updateCheckBox:(BOOL)choosed;

@end

NS_ASSUME_NONNULL_END
