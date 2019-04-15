//
//  YbsNavTitleView.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YbsTitleViewStyle) {
    YbsTitleViewStyleNormal,
    YbsTitleViewStyleSegement
};

typedef void(^SegementClickBlock)(NSInteger);

@protocol YbsTitleViewDelegate<NSObject>
- (void)onTitleClick;
@end

NS_ASSUME_NONNULL_BEGIN

@interface YbsNavTitleView : UIView

@property (nonatomic, weak) id <YbsTitleViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy  ) NSString *titleString;
@property (nonatomic, strong) UISegmentedControl *segementControl;
@property (nonatomic, copy  ) SegementClickBlock block;

- (instancetype)initWithFrame:(CGRect)frame style:(YbsTitleViewStyle)style;

@end

NS_ASSUME_NONNULL_END
