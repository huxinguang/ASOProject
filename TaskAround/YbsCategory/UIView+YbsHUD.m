//
//  UIView+YbsHUD.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/18.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "UIView+YbsHUD.h"

@implementation UIView (YbsHUD)

- (void)showHudWithMessage:(NSString*)message{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.font = kYbsFontCustom(15);
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1];
}

@end
