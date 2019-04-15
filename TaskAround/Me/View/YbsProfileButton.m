//
//  YbsProfileButton.m
//  XGDemo
//
//  Created by 胡辉 on 2019/2/21.
//  Copyright © 2019 胡辉. All rights reserved.
//

#import "YbsProfileButton.h"

#define kImageH 28
#define kImageW 28
#define kTitleH 20
#define kSubTitleH 18


@interface YbsProfileButton ()

@property (nonatomic,weak) id target;
@property (nonatomic, assign) SEL action;
/// 图标
@property (nonatomic, strong) UIImageView *imageView;
/// title

/// subtitle


@end

@implementation YbsProfileButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.imageView = [[UIImageView alloc] init];
    [self addSubview:self.imageView];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.font = kYbsFontCustom(15);
    self.titleLab.textColor = kColorHex(@"#676767");
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLab];
    
    self.subTitleLab = [[UILabel alloc] init];
    self.subTitleLab.font = kYbsFontCustom(13);
    self.subTitleLab.textColor = kColorHex(@"#FF2F29");
    self.subTitleLab.textAlignment = NSTextAlignmentCenter;
    self.subTitleLab.hidden = YES;
    [self addSubview:self.subTitleLab];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLab.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    if (!subTitle) {
        return;
    }
    self.subTitleLab.text = subTitle;
    self.subTitleLab.hidden = NO;
}
- (void)setFont:(UIFont *)font {
    _font = font;
    self.titleLab.font = font;
}
- (void)setSubTitleFont:(UIFont *)subTitleFont {
    _subTitleFont = subTitleFont;
    self.subTitleLab.font = subTitleFont;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(self.width/2 - kImageW/2, self.height/2 - (kImageH + 7 + kTitleH)/2, kImageW, kImageH);
    self.titleLab.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 7, CGRectGetWidth(self.frame), kTitleH);
    self.subTitleLab.frame = CGRectMake(0, CGRectGetMaxY(self.titleLab.frame), CGRectGetWidth(self.frame), 15);
}

- (void)addTarget:(id)target action:(SEL)action {
    self.target = target;
    self.action = action;
}

//当button点击结束时，如果结束点在button区域中执行action方法
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touche = [touches anyObject];
    CGPoint point = [touche locationInView:self];
    
    if (CGRectContainsPoint(self.bounds, point)) {
        if (self.target) {
            [self.target performSelector:self.action withObject:self];
        }
    }
}

@end
