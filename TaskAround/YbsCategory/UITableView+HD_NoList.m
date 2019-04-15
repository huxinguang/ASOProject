//
//  UITableView+HD_NoList.m
//  houDaProject
//
//  Created by 波 on 2017/8/8.
//  Copyright © 2017年 heiguoliangle. All rights reserved.
//

#import "UITableView+HD_NoList.h"
#import "UIView+YYAdd.h"
#import <objc/runtime.h>
@implementation UITableView (HD_NoList)

static const void *kshowNoView = @"kshowNoView";

-(UIImageView *)im{
    UIImageView *im = [[UIImageView alloc]init];
    im.image = [UIImage imageNamed:@"icon_noting_face"];
    im.contentMode =UIViewContentModeCenter;
    return im  ;
}

-(UILabel *)label{
    UILabel *_label = [[UILabel alloc]init];
    _label.textColor = kColorHex(@"#999999");
    _label.font = kYbsFontCustom(16);
    _label.text = @"暂无数据";
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentCenter;
    return _label;
}
-(UIView *)containerV{
    UIView *v = [[UIView alloc]init];
    v.tag = 8808;
    return v;
}


#pragma mark - BOOL类型的动态绑定
- (BOOL)showNoView {
    return [objc_getAssociatedObject(self, kshowNoView) boolValue];
}
-(BOOL)isShowNoView{
    return [objc_getAssociatedObject(self, kshowNoView) boolValue];
}
- (void)setShowNoView:(BOOL)showNoView {
    objc_setAssociatedObject(self, kshowNoView, [NSNumber numberWithBool:showNoView], OBJC_ASSOCIATION_ASSIGN);
}

-(void)showNoView:(NSString *)title image:(UIImage *)placeImage certer:(CGPoint)p{
    
    UIView *containerV = [self containerV];
    containerV.width =[UIScreen mainScreen].bounds.size.width;
    UILabel *label = [self label];
    UIImageView *imgView = [self im];

    if (title) {
         label.text = title;
    }
    if (placeImage) {
         imgView.image =placeImage;
    }

    imgView.size = imgView.image.size;
    imgView.top = 0;
    imgView.centerX = containerV.width/2.0;
    label.width =containerV.width;
    [label sizeToFit];
    label.centerX = containerV.width/2.0;
    label.top = CGRectGetMaxY(imgView.frame)+20;
    
    containerV.height = CGRectGetMaxY(label.frame);
    

    containerV.bottom = self.centerY - self.top;
    
    [containerV addSubview:imgView];
    [containerV addSubview:label];
    [self addSubview: containerV];
    [self setShowNoView:YES];
    
}
-(void)dismissNoView{
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == 8808) {
            [obj removeFromSuperview];
            [self setShowNoView:NO];
        }
    }];
}
@end
