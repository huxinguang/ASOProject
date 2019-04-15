//
//  YbsProfileButton.h
//  XGDemo
//
//  Created by 胡辉 on 2019/2/21.
//  Copyright © 2019 胡辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface YbsProfileButton : UIView

/// 按钮名称
@property (nonatomic, strong) NSString *title;
/// 图标
@property (nonatomic, strong) UIImage *image;
/// 副标题
@property (nonatomic, strong) NSString *subTitle;
/// 字体大小
@property (nonatomic, strong) UIFont *font;
/// 字体颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 副标题字体大小
@property (nonatomic, strong) UIFont *subTitleFont;
/// 副标题字体颜色
@property (nonatomic, strong) UIColor *subTitleColor;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *subTitleLab;

- (void)addTarget:(id )target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
