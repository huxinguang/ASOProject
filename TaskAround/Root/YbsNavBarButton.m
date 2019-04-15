//
//  YbsNavBarButton.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsNavBarButton.h"

@implementation YbsBarButtonConfiguration

@end

@implementation YbsNavBarButton


- (instancetype)initWithFrame:(CGRect)frame configuration:(YbsBarButtonConfiguration *)config{
    self = [super initWithFrame:frame];
    if (self) {
        self.configuration = config;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setConfiguration:(YbsBarButtonConfiguration *)configuration{
    if (!configuration) {
        return;
    }
    switch (configuration.type) {
        case YbsBarButtonTypeBack:
            if (configuration.normalImageName) {
                [self setImage:[UIImage imageNamed:configuration.normalImageName] forState:UIControlStateNormal];
            }
            break;
        case YbsBarButtonTypeImage:
            if (configuration.normalImageName) {
                [self setImage:[UIImage imageNamed:configuration.normalImageName] forState:UIControlStateNormal];
            }
            if (configuration.selectedImageName) {
                [self setImage:[UIImage imageNamed:configuration.selectedImageName] forState:UIControlStateSelected];
            }
            if (configuration.highlightedImageName) {
                [self setImage:[UIImage imageNamed:configuration.highlightedImageName] forState:UIControlStateHighlighted];
            }
            break;
        case YbsBarButtonTypeText:
            [self setTitle:configuration.titleString ? configuration.titleString: @""forState:UIControlStateNormal];
            self.titleLabel.font = configuration.titleFont;
            if (configuration.normalColor) {
                [self setTitleColor:configuration.normalColor forState:UIControlStateNormal];
            }
            if (configuration.selectedColor) {
                [self setTitleColor:configuration.selectedColor forState:UIControlStateSelected];
            }
            if (configuration.highlightedColor) {
                [self setTitleColor:configuration.highlightedColor forState:UIControlStateHighlighted];
            }
            if (configuration.disabledColor) {
                [self setTitleColor:configuration.disabledColor forState:UIControlStateDisabled];
            }
            break;
            
        default:
            break;
    }
    
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    [self setTitle: titleStr forState:UIControlStateNormal];
}



@end
