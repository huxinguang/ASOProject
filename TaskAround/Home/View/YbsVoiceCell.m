//
//  YbsVoiceCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/18.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsVoiceCell.h"

@interface YbsVoiceCell ()



@end

@implementation YbsVoiceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews{
    
    self.addIcon = [UIImageView new];
    self.addIcon.image = kImageNamed(@"add");
    [self.contentView addSubview:self.addIcon];
    [self.addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.container = [UIView new];
    [self.contentView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.left.and.right.equalTo(self.contentView);
        make.size.height.mas_equalTo(30+20);
    }];
    
    self.imgView = [UIImageView new];
    self.imgView.image = kImageNamed(@"voice");
    [self.container addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container);
        make.centerX.equalTo(self.container);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.text = @"0:00";
    self.timeLabel.font = kYbsFontCustom(14);
    [self.container addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom);
        make.left.and.right.equalTo(self.container);
    }];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:kImageNamed(@"selected_delete") forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(3);
        make.right.equalTo(self.contentView).with.offset(-3);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    

}


+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

- (void)updateConstraints{

    [super updateConstraints];
}


@end
