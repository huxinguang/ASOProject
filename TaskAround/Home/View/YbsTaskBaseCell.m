//
//  YbsTaskBaseCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/27.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsTaskBaseCell.h"

@implementation YbsTaskBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildSubViews];
    }return self;
}

- (void)buildSubViews{
    self.backgroundColor = kColorHex(@"#F1F1F1");
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.taskLeftImgView];
    [self.containerView addSubview:self.taskNameLabel];
    [self.containerView addSubview:self.locationImageView];
    [self.containerView addSubview:self.addressLabel];
    [self.containerView addSubview:self.shopNameLabel];
}

-(void)setModel:(YbsTaskModel *)model{
    _model = model;
    self.taskNameLabel.text = model.taskName;
    self.shopNameLabel.text = model.storeName;
    self.addressLabel.text = model.address;
}

#pragma mark-setter,getter

- (UIView *)containerView{
    if(!_containerView){
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIImageView *)taskLeftImgView{
    if (_taskLeftImgView==nil) {
        _taskLeftImgView=[[UIImageView alloc] init];
        _taskLeftImgView.image = kImageNamed(@"task_left_img");
    }
    return _taskLeftImgView;
}

-(UILabel *)taskNameLabel{
    if (_taskNameLabel==nil) {
        _taskNameLabel=[[UILabel alloc] init];
        _taskNameLabel.text = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
        _taskNameLabel.font=kYbsFontCustomBold(17);
        _taskNameLabel.textColor=kColorHex(@"#2F2F2F");
    }
    return _taskNameLabel;
}

- (UIImageView *)locationImageView{
    if (_locationImageView==nil) {
        _locationImageView=[[UIImageView alloc] init];
        _locationImageView.image = kImageNamed(@"task_location");
    }
    return _locationImageView;
}

- (UILabel *)addressLabel{
    if (_addressLabel==nil) {
        _addressLabel=[[UILabel alloc] init];
        _addressLabel.font=kYbsFontCustom(16);
        _addressLabel.textColor=kColorHex(@"#2F2F2F");
        _addressLabel.numberOfLines = 2;
        
    }
    return _addressLabel;
}


-(UILabel *)shopNameLabel{
    if (_shopNameLabel==nil) {
        _shopNameLabel=[[UILabel alloc] init];
        _shopNameLabel.font=kYbsFontCustom(13);
        _shopNameLabel.textColor=kColorHex(@"#999999");
        _shopNameLabel.numberOfLines = 1;
    }return _shopNameLabel;
}

+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

- (NSString *)formattedDistance:(NSInteger)meters{
    if (meters < 1000) {
        return [NSString stringWithFormat:@"%ldm",meters];
    }else{
        NSInteger km = meters/1000;
        NSInteger bm = (meters%1000)/100;
        if (bm == 0) {
            return [NSString stringWithFormat:@"%ldkm",km];
        }else{
            return [NSString stringWithFormat:@"%ld.%ldkm",km,bm];
        }
        
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
