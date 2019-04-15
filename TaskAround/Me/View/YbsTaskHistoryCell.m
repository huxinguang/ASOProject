//
//  YbsTaskHistoryCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/27.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskHistoryCell.h"

@implementation YbsTaskHistoryCell

-(void)setModel:(YbsTaskModel *)model{
    [super setModel:model];
    self.moneyLabel.text = model.payMoney;
    self.statusLabel.text = model.status;
    if ([model.status isEqualToString:@"0"]) {
        self.statusLabel.text = @"奖励未发放";
        self.statusLabel.textColor = kColorHex(@"#FFA600");
    }else if ([model.status isEqualToString:@"1"]){
        self.statusLabel.text = @"奖励已发放";
        self.statusLabel.textColor = kColorHex(@"#FFA600");
    }else if ([model.status isEqualToString:@"2"]){
        self.statusLabel.text = @"任务失败";
        self.statusLabel.textColor = kColorHex(@"#999999"); 
    }

}

-(void)buildSubViews{
    [super buildSubViews];
    self.taskNameLabel.numberOfLines = 0;
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.statusLabel];
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

-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = kYbsFontCustom(13);
        _statusLabel.textColor = kColorHex(@"#999999");
    }
    return _statusLabel;
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
        make.left.equalTo(self.taskLeftImgView.mas_right).with.offset(5);
        make.centerY.equalTo(self.taskLeftImgView);
        make.right.equalTo(self.moneyLabel.mas_left);
        make.height.mas_equalTo(21);
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
        make.top.equalTo(self.locationImageView).with.offset(-2);
        make.left.equalTo(self.locationImageView.mas_right).with.offset(3);
        make.right.equalTo(self.containerView).with.offset(-100);
    }];
    
    
    [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel);
        make.top.equalTo(self.addressLabel.mas_bottom).with.offset(10);
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shopNameLabel);
        make.right.equalTo(self.containerView).with.offset(-10);
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
