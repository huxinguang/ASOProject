//
//  YbsAwardView.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/25.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsAwardView.h"

@interface YbsAwardView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UILabel *centerLeftLabel;
@property (nonatomic, strong) UILabel *centerRightLabel;

@end

@implementation YbsAwardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubViews];
    }
    return self;
}


- (void)buildSubViews{
    [self addSubview:self.imageView];
    [self addSubview:self.openBtn];
//    [self addSubview:self.loginBtn];
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.image = kImageNamed(@"hongbao_unopen");
        if (kAppScreenWidth == 320) {
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
        }else{
            _imageView.contentMode = UIViewContentModeCenter;
        }
        
        _imageView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
        _imageView.frame = CGRectMake(0, 0, kAppScreenWidth, kAppScreenHeight);
    }
    return _imageView;
}

- (UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openBtn.frame = CGRectMake(kAppScreenWidth/2-90/2, [self openBtnOriginY], 90, 90);
        [_openBtn setImage:kImageNamed(@"hongbao_open_btn") forState:UIControlStateNormal];
        [_openBtn addTarget:self action:@selector(openBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openBtn;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.backgroundColor = kColorHex(@"#FFFBD3");
        [_loginBtn setTitleColor:kColorHex(@"#E8290E") forState:UIControlStateNormal];
        [_loginBtn setTitle:@"去登录>>" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)centerLeftLabel{
    if (!_centerLeftLabel) {
        _centerLeftLabel=[[UILabel alloc] init];
        _centerLeftLabel.text = @"5";
        _centerLeftLabel.font = [UIFont boldSystemFontOfSize:60];
        _centerLeftLabel.font = kYbsFontCustomBold(60);
        _centerLeftLabel.textAlignment = NSTextAlignmentRight;
        _centerLeftLabel.textColor =  kColorHex(@"#FFE0B1");
        
    }
    return _centerLeftLabel;
}

- (UILabel *)centerRightLabel{
    if (!_centerRightLabel) {
        _centerRightLabel=[[UILabel alloc] init];
        _centerRightLabel.text = @"元";
//        _centerRightLabel.font = [UIFont boldSystemFontOfSize:23];
        _centerRightLabel.font = kYbsFontCustomBold(23);
        _centerRightLabel.textAlignment=NSTextAlignmentRight;
        _centerRightLabel.textColor=kColorHex(@"#FFE0B1");
    }
    return _centerRightLabel;
}


- (CGFloat)openBtnOriginY{
    if (kAppScreenHeight == 480) {
        return 80;
    }else if (kAppScreenHeight == 568) {
        return 80;
    }else if (kAppScreenHeight == 667){
        return 80;
    }else if (kAppScreenHeight == 736){
        return 80;
    }else if (kAppScreenHeight == 812){
        return 80;
    }else{
        return 80;
    }
}


#pragma mark - Action

- (void)openBtnAction{
    
}

- (void)loginBtnAction{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
