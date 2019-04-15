//
//  BackView.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/11.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "BackView.h"

@implementation BackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    UINavigationBar *navBar = nil;
    UIView *aView = self.superview;
    while (aView) {
        if ([aView isKindOfClass:[UINavigationBar class]]) {
            navBar = (UINavigationBar *)aView;
            break;
        }
        aView = aView.superview;
    }
    UINavigationItem * navItem = (UINavigationItem *)navBar.items.lastObject;
    UIBarButtonItem *leftItem = navItem.leftBarButtonItem;
    UIBarButtonItem *rightItem = navItem.rightBarButtonItem;
    if (rightItem) {//右边按钮
        BackView *backView = rightItem.customView;
        if ([backView isKindOfClass:self.class]) {
            backView.btn.left = backView.width -backView.btn.width;
        }
    }
    if (leftItem) {//左边按钮

    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
