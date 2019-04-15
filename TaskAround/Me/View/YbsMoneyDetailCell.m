//
//  YbsMoneyDetailCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsMoneyDetailCell.h"

@implementation YbsMoneyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildSubViews];
        [self addConstraints];
    }
    return self;
}

- (void)buildSubViews{
    [self.contentView addSubview:self.leftTopLabel];
    [self.contentView addSubview:self.rightTopLabel];
    [self.contentView addSubview:self.leftBottomLabel];
    [self.contentView addSubview:self.rightBottomLabel];
    [self.contentView addSubview:self.lineView];
}


- (void)setModel:(YbsMoneyDetailModel *)model{
    _model = model;
    
    if ([model.type isEqualToString:@"1"]) {
        self.leftTopLabel.text = @"完成任务";
    }else if ([model.type isEqualToString:@"2"]){
        self.leftTopLabel.text = @"提现";
    }else if ([model.type isEqualToString:@"3"]){
        self.leftTopLabel.text = @"红包";
    }else{
        self.leftTopLabel.text = @"其他";
    }
    self.leftBottomLabel.text = model.taskName;
    if ([model.moneyType isEqualToString:@"1"]) {
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@",model.money];
        self.rightTopLabel.textColor = kColorHex(@"#FF2F29");
    }else{
        self.rightTopLabel.text = [NSString stringWithFormat:@"%@",model.money];
        self.rightTopLabel.textColor = kColorHex(@"#16BE07");
    }
    
    self.rightBottomLabel.text = model.createTime;
}


- (void)addConstraints{
    [self.leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(5);
        make.left.equalTo(self.contentView).with.offset(16);
    }];
    
    [self.rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-16);
    }];
    
    [self.leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(16);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    
    [self.rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-16);
        make.bottom.equalTo(self.contentView).with.offset(-5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (UILabel *)leftTopLabel{
    if (!_leftTopLabel) {
        _leftTopLabel = [[UILabel alloc] init];
        _leftTopLabel.text = @"完成任务";
        _leftTopLabel.font = kYbsFontCustom(16);
        _leftTopLabel.textAlignment = NSTextAlignmentLeft;
        _leftTopLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _leftTopLabel;
}

- (UILabel *)rightTopLabel{
    if (!_rightTopLabel) {
        _rightTopLabel = [[UILabel alloc] init];
        _rightTopLabel.text = @"+10.00";
        _rightTopLabel.font = kYbsFontCustom(20);
        _rightTopLabel.textAlignment = NSTextAlignmentRight;
        _rightTopLabel.textColor = kColorHex(@"#FF2F29");
    }
    return _rightTopLabel;
}

- (UILabel *)leftBottomLabel{
    if (!_leftBottomLabel) {
        _leftBottomLabel = [[UILabel alloc] init];
        _leftBottomLabel.text = @"维维豆奶";
        _leftBottomLabel.font = kYbsFontCustom(13);
        _leftBottomLabel.textAlignment = NSTextAlignmentLeft;
        _leftBottomLabel.textColor = kColorHex(@"#999999");
    }
    return _leftBottomLabel;
}

- (UILabel *)rightBottomLabel{
    if (!_rightBottomLabel) {
        _rightBottomLabel = [[UILabel alloc] init];
        _rightBottomLabel.text = @"2018-09-01";
        _rightBottomLabel.font = kYbsFontCustom(13);
        _rightBottomLabel.textAlignment = NSTextAlignmentRight;
        _rightBottomLabel.textColor = kColorHex(@"#999999");
    }
    return _rightBottomLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _lineView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
