//
//  YbsTaskHomeCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/27.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskHomeCell.h"

@interface YbsTaskHomeCell ()

@end

@implementation YbsTaskHomeCell

-(void)setModel:(YbsTaskModel *)model{
    [super setModel:model];
    
    NSString *str = [NSString stringWithFormat:@"￥%@",model.money];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedString addAttribute:NSFontAttributeName value:kYbsFontCustom(15) range:NSMakeRange(0,1)];
    [attributedString addAttribute:NSFontAttributeName value:kYbsFontCustom(20) range:NSMakeRange(1,str.length-1)];
    self.moneyLabel.attributedText = attributedString;
    self.timeLabel.text = model.endTime;
    self.distanceLabel.text = model.distance;
}

-(void)buildSubViews{
    [super buildSubViews];
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.masksToBounds = YES;
    [self.containerView addSubview:self.moneyLabel];
    [self.containerView addSubview:self.lineView];
    [self.containerView addSubview:self.distanceLabel];
    [self.containerView addSubview:self.timeLabel];
}

#pragma mark-setter,getter

-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.text = @"99.99";
//        _moneyLabel.font = kYbsFontCustom(20);
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = kColorHex(@"#FF2F29");
    }
    return _moneyLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _lineView;
}

-(UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        [_distanceLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        _distanceLabel.font = kYbsFontCustom(14);
        _distanceLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _distanceLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kYbsFontCustom(13);
        _timeLabel.textColor = kColorHex(@"#999999");
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

- (void)updateConstraints{
    [super updateConstraints];

    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.bottom.equalTo(self.contentView).with.offset(-10);
    }];
    
    [self.taskLeftImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).with.offset(15);
        make.left.equalTo(self.containerView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];

    [self.taskNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.taskLeftImgView.mas_right).with.offset(5);
        make.centerY.equalTo(self.taskLeftImgView);
        make.right.equalTo(self.timeLabel.mas_left);
        make.height.mas_equalTo(21);
    }];

    [self.moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.taskNameLabel);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.width.mas_equalTo([self getTimeLabelWidth]);
        make.height.equalTo(self.taskNameLabel);
    }];

    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).with.offset(5);
        make.left.equalTo(self.containerView).with.offset(5);
        make.right.equalTo(self.containerView).with.offset(-5);
        make.height.mas_equalTo(0.5);
    }];

    [self.locationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
        make.left.equalTo(self.taskLeftImgView);
        make.size.mas_equalTo(CGSizeMake(9.5, 13));
    }];

    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationImageView).with.offset(-2);
        make.left.equalTo(self.locationImageView.mas_right).with.offset(3);
        make.right.equalTo(self.timeLabel.mas_left);
    }];

    [self.distanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locationImageView);
        make.right.equalTo(self.moneyLabel);
    }];

    [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel);
        make.bottom.equalTo(self.containerView).with.offset(-10);
        make.right.equalTo(self.timeLabel.mas_left);
    }];

    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shopNameLabel);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.width.mas_equalTo([self getTimeLabelWidth]);
    }];

}

- (CGFloat)getTimeLabelWidth{
    NSString *timeStr = @"2020-00-00";
    return [timeStr widthForFont:self.timeLabel.font]+5;
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
