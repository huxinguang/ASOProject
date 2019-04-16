//
//  YbsMessageCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/4/11.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsMessageCell.h"

@implementation YbsMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.dotView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.lineView];
        
        [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(7);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(7, 7));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dotView.mas_right).with.offset(5);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.timeLabel.mas_left);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(100);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
    
    }
    return self;
}

-(UIImageView *)dotView{
    if (!_dotView) {
        _dotView = [[UIImageView alloc]initWithImage:kImageNamed(@"profile_message_dot")];
    }
    return _dotView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.font = kYbsFontCustomBold(16);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _titleLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = kYbsFontCustom(14);
        _timeLabel.textColor = kColorHex(@"#999999");
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = kColorHex(@"#D0D0D0");
    }
    return _lineView;
}


- (void)setModel:(YbsMessageModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.createTime;
    if ([model.hasRead isEqualToString:@"0"]) {//未读
        self.dotView.hidden = NO;
    }else{//已读
        self.dotView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
