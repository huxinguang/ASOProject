//
//  YbsNavBarButton.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YbsBarButtonType) {
    YbsBarButtonTypeBack,
    YbsBarButtonTypeImage,
    YbsBarButtonTypeText
};

NS_ASSUME_NONNULL_BEGIN

@interface YbsBarButtonConfiguration : NSObject
@property (nonatomic, copy  ) NSString *normalImageName;
@property (nonatomic, copy  ) NSString *selectedImageName;
@property (nonatomic, copy  ) NSString *highlightedImageName;
@property (nonatomic, copy  ) NSString *titleString;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *disabledColor;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, assign) YbsBarButtonType type;

@end

@interface YbsNavBarButton : UIButton

@property (nonatomic, strong) YbsBarButtonConfiguration *configuration;
@property (nonatomic, strong) NSString *titleStr;

- (instancetype)initWithFrame:(CGRect)frame configuration:(YbsBarButtonConfiguration *)config;

@end

NS_ASSUME_NONNULL_END
