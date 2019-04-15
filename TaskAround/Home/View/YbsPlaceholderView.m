//
//  YbsPlaceHolderView.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsPlaceholderView.h"

#define kYbsPlaceholderImageSize    CGSizeMake(72, 72)
#define kYbsPlaceholderButtonSize   CGSizeMake(140, 44)

@interface YbsPlaceholderView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIButton *button;

@end

@implementation YbsPlaceholderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = kColorHex(@"#fafafa");
        [self addSubview:self.imageView];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [UILabel new];
        _msgLabel.font = kYbsFontCustom(16);
        _msgLabel.textColor = kColorHex(@"4c4c4c");
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.numberOfLines = 0;
        [self addSubview:_msgLabel];
    }
    return _msgLabel;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackgroundColor:kColorHex(kYbsThemeColor)];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font = kYbsFontCustom(18);
        _button.layer.cornerRadius = 22;
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(onBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return _button;
}

- (void)setType:(YbsPlaceholderType)type{
    if (_type != type) {
        _type = type;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
}

- (void)setImageName:(NSString *)imageName{
    if (![_imageName isEqualToString:imageName]) {
        _imageName = imageName;
        self.imageView.image = kImageNamed(imageName);
    }
}

- (void)setMsg:(NSString *)msg{
    if (![_msg isEqualToString:msg]) {
        _msg = msg;
        self.msgLabel.text = _msg;
    }
}

-(void)setBtnTitle:(NSString *)btnTitle{
    if (![_btnTitle isEqualToString:btnTitle]) {
        _btnTitle = btnTitle;
        [self.button setTitle:_btnTitle forState:UIControlStateNormal];
    }
}

- (void)setClickBlock:(PlaceholderClickBlock)clickBlock{
    if (_clickBlock != clickBlock) {
        _clickBlock = clickBlock;
    }
}

- (void)onBtnClick{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    switch (self.type) {
        case YbsPlaceholderTypeButton:
        {
            [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.left.and.right.equalTo(self);
            }];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.msgLabel.mas_top).with.offset(-20);
                make.size.mas_equalTo(kYbsPlaceholderImageSize);
            }];
            [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.msgLabel.mas_bottom).with.offset(20);
                make.size.mas_equalTo(kYbsPlaceholderButtonSize);
            }];
        }
            break;
        case YbsPlaceholderTypeNoButton:
        {
            [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.left.and.right.equalTo(self);
            }];
            [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.msgLabel.mas_top).with.offset(-15);
                make.size.mas_equalTo(kYbsPlaceholderImageSize);
            }];
            [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self.msgLabel.mas_bottom).with.offset(20);
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
        }
            
            break;
        default:
            break;
    }
    
    [super updateConstraints];
}

/*
 使用Masonry自动布局的View，在添加/更新约束后并不能获取到其frame，所以设置圆角无效，需要调用layoutIfNeeded后才能立即获取frame
 
 Masonry is a wrapper for autolayouts, and autolayouts calculate itself frame in - (void)layoutSubviews; method, and only after that u can get frames of all views.
 
 masonry methods mas_makeConstraints and similar just setups Constraints no more.
 
 And if you need update constraints you must call mas_remakeConstraints: its just update constraits, for update Frames of views, we must call method setNeedsLayout for setup a flag about recalculation in next Display cycle, and if we want update frames immediately we must call layoutIfNeeded method.
 */

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.button.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(22.0f,22.0f)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.button.bounds;
    maskLayer.path = maskPath.CGPath;
    self.button.layer.mask = maskLayer;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
