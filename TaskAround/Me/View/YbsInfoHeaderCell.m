//
//  YbsInfoHeaderCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/22.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsInfoHeaderCell.h"

@interface YbsInfoHeaderCell ()

@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation YbsInfoHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildSubViews];
        [self addConstraints];
    }
    return self;
}

- (void)buildSubViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.avatarImgView];
    [self.contentView addSubview:self.lineView];
    
    self.avatarImgView.layer.cornerRadius = 100*kAppScreenWidth/375*0.6/2;
    self.avatarImgView.layer.masksToBounds = YES;
}

- (void)addConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(4.5, 10.5));
    }];
    
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.arrowImgView.mas_left).with.offset(-10);
        make.width.mas_equalTo(self.contentView.mas_height).multipliedBy(0.6);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.6);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.font = kYbsFontCustom(15);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kColorHex(@"#2F2F2F");
    }
    return _titleLabel;
}

-(UIImageView *)avatarImgView{
    if (!_avatarImgView) {
        _avatarImgView = [UIImageView new];
        _avatarImgView.image = kImageNamed(@"profile_info_avatar");
    }
    return _avatarImgView;
}


- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [UIImageView new];
        _arrowImgView.image = kImageNamed(@"profile_setting_arrow");
    }
    return _arrowImgView;
}

-(UIView *)lineView{
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
