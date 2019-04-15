//
//  YbsPlaceHolderView.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YbsPlaceholderType) {
    YbsPlaceholderTypeNoButton,
    YbsPlaceholderTypeButton
};

typedef void(^PlaceholderClickBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface YbsPlaceholderView : UIView

@property (nonatomic, assign) YbsPlaceholderType type;
@property (nonatomic, copy  ) NSString *msg;
@property (nonatomic, copy  ) NSString *imageName;
@property (nonatomic, copy  ) NSString *btnTitle;
@property (nonatomic, copy  ) PlaceholderClickBlock clickBlock;

@end

NS_ASSUME_NONNULL_END
