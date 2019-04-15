//
//  UIBarButtonItem+YbsAdd.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/11.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (YbsAdd)

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
