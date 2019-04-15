//
//  YbsTaskUncommitCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/6.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskUncommitCell.h"

#define kCommitBtnSize CGSizeMake(80*kScreenWidth/375, 30*kScreenWidth/375)

@implementation YbsTaskUncommitCell

-(void)setModel:(YbsTaskModel *)model{
    [super setModel:model];
    self.moneyLabel.text = model.payMoney;
    
}

-(void)buildSubViews{
    [super buildSubViews];
    self.taskNameLabel.numberOfLines = 2;
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.commitBtn];
    self.commitBtn.layer.cornerRadius = 3;
    self.commitBtn.layer.masksToBounds = YES;
}

#pragma mark-setter,getter

-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"99.99";
        _moneyLabel.font = kYbsFontCustom(20);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = kColorHex(@"#FF2F29");
    }
    return _moneyLabel;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitBtn.backgroundColor = kColorHex(@"#FFA600");
        [_commitBtn setTitle:@"立即提交" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = kYbsFontCustom(15);
    }
    return _commitBtn;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    
    [self.taskLeftImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).with.offset(20);
        make.left.equalTo(self.containerView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [self.taskNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskLeftImgView).with.offset(-3.5);
        make.left.equalTo(self.taskLeftImgView.mas_right).with.offset(5);
        make.right.equalTo(self.containerView).with.offset(-(kCommitBtnSize.width + 20));
    }];
    
    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.taskLeftImgView);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.width.mas_equalTo(55*kAppScreenWidth/375);
    }];
    
    [self.locationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.taskLeftImgView);
        make.size.mas_equalTo(CGSizeMake(9.5, 13));
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationImageView).with.offset(-3.5);
        make.left.equalTo(self.locationImageView.mas_right).with.offset(3);
        make.right.equalTo(self.containerView).with.offset(-(kCommitBtnSize.width + 20));
    }];
    
    [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel);
        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-10);
    }];
    
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.size.mas_equalTo(kCommitBtnSize);
    }];
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
