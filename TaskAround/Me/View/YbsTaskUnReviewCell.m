//
//  YbsTaskUnReviewCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/7.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskUnReviewCell.h"

#define kAppealBtnSize CGSizeMake(80*kScreenWidth/375, 30*kScreenWidth/375)

@implementation YbsTaskUnReviewCell

- (void)setCellType:(CellType)cellType{
    _cellType = cellType;
    if (cellType == CellTypeUnReview) {
        self.appealBtn.hidden = YES;
        self.statusLabel.hidden = NO;
    }else{
        self.appealBtn.hidden = NO;
        self.statusLabel.hidden = YES;
    }
}


-(void)setModel:(YbsTaskModel *)model{
    [super setModel:model];
    if ([model.status isEqualToString:@"0"]) {
        self.statusLabel.text = @"待审核";
    }else{
        self.statusLabel.text = @"已申诉";
    }
}

-(void)buildSubViews{
    [super buildSubViews];
    self.taskNameLabel.numberOfLines = 2;
    [self.containerView addSubview:self.statusLabel];
    [self.containerView addSubview:self.appealBtn];
    self.appealBtn.layer.cornerRadius = 3;
    self.appealBtn.layer.masksToBounds = YES;
}

-(UILabel *)statusLabel{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = kYbsFontCustom(13);
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _statusLabel;
}

- (UIButton *)appealBtn{
    if (!_appealBtn) {
        _appealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _appealBtn.backgroundColor = kColorHex(@"#FFA600");
        [_appealBtn setTitle:@"申请申诉" forState:UIControlStateNormal];
        [_appealBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _appealBtn.titleLabel.font = kYbsFontCustom(15);
    }
    return _appealBtn;
}

- (void)updateConstraints{
    [super updateConstraints];
    
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.bottom.and.right.equalTo(self);
        make.top.equalTo(self.contentView).with.offset(10);
    }];
    
    [self.taskLeftImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).with.offset(20);
        make.left.equalTo(self.containerView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
    [self.taskNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskLeftImgView).with.offset(-5);
        make.left.equalTo(self.taskLeftImgView.mas_right).with.offset(5);
        make.right.equalTo(self.containerView).with.offset(-(kAppealBtnSize.width + 20));
    }];
    
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.taskLeftImgView);
        make.right.equalTo(self.containerView).with.offset(-25*kAppScreenWidth/375);
        make.width.mas_equalTo(50*kAppScreenWidth/375);
    }];
    
    [self.locationImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskNameLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.taskLeftImgView);
        make.size.mas_equalTo(CGSizeMake(9.5, 13));
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationImageView).with.offset(-3.5);
        make.left.equalTo(self.locationImageView.mas_right).with.offset(3);
        make.right.equalTo(self.containerView).with.offset(-(kAppealBtnSize.width + 20));
    }];
    
    [self.shopNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressLabel);
        make.bottom.equalTo(self.containerView.mas_bottom).with.offset(-10);
    }];
    
    [self.appealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView);
        make.right.equalTo(self.containerView).with.offset(-10);
        make.size.mas_equalTo(kAppealBtnSize);
    }];
}

- (CGFloat)getStatusLabelWidth{
    NSString *timeStr = @"奖励已发放";
    return [timeStr widthForFont:self.statusLabel.font]+5;
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
