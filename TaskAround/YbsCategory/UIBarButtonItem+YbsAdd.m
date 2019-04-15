//
//  UIBarButtonItem+YbsAdd.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/11.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "UIBarButtonItem+YbsAdd.h"
#import "BackView.h"

@implementation UIBarButtonItem (YbsAdd)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action {
    BackView *customView = [[BackView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [customView addGestureRecognizer:tap];
    customView.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    customView.btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    if (icon) {
        [customView.btn setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    }
    if (highIcon) {
        [customView.btn setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    }
    customView.btn.frame = CGRectMake(0, 0, customView.btn.currentBackgroundImage.size.width, customView.btn.currentBackgroundImage.size.height);
    customView.btn.centerY = customView.centerY;
    [customView.btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:customView.btn];
    return  [[UIBarButtonItem alloc] initWithCustomView:customView];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn setTitleColor:kColorHex(@"#ffffff") forState:UIControlStateNormal];
    [btn setTitleColor:kColorHex(@"#ffffff") forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    btn.frame = CGRectMake(0, 0, title.length * 18, 30);
    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}


@end
