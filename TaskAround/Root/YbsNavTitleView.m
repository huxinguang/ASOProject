//
//  YbsNavTitleView.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsNavTitleView.h"

@interface YbsNavTitleView ()

@property (nonatomic, assign) YbsTitleViewStyle style;

@end

@implementation YbsNavTitleView

- (instancetype)initWithFrame:(CGRect)frame style:(YbsTitleViewStyle)style{
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews{
    switch (self.style) {
        case YbsTitleViewStyleNormal:
        {
            self.titleLabel = [[UILabel alloc]init];
            self.titleLabel.font = kYbsFontCustomBold(kYbsNavigationTitleViewTitleFontSize);
            self.titleLabel.frame = CGRectMake(0, 0, kYbsNavigationTitleViewMaxWidth, kYbsNavigationTitleViewHeight);
            self.titleLabel.textColor = kColorHex(kYbsNavigationTitleViewTitleColor);
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.titleLabel];
            
            self.autoresizingMask  = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin ;
        }
            break;
        case YbsTitleViewStyleSegement:
        {
            self.segementControl = [[UISegmentedControl alloc]initWithItems:@[@"地图",@"列表"]];
            self.segementControl.frame = CGRectMake(self.width/2-160/2, self.height/2-28/2, 160, 28);
            
            self.segementControl.tintColor = [UIColor whiteColor];
            self.segementControl.selectedSegmentIndex = 0;
            [self.segementControl addTarget:self action:@selector(segementClick:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:self.segementControl];
        }
            break;
        default:
            break;
    }
    
}

- (void)setTitleString:(NSString *)titleString{
    self.titleLabel.text = titleString;
}

- (void)segementClick:(UISegmentedControl *)segement{
    if (self.block) {
        self.block(segement.selectedSegmentIndex);
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
