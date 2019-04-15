//
//  YbsVoiceCell.h
//  TaskAround
//
//  Created by xinguang hu on 2019/2/18.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsVoiceCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *addIcon;

@end

NS_ASSUME_NONNULL_END
