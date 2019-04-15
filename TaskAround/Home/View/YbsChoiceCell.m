//
//  YbsChoiceCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/19.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsChoiceCell.h"

@implementation YbsChoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews{
    self.checkBox = [UIImageView new];
    self.checkBox.image = kImageNamed(@"choice_nor");
    [self.contentView addSubview:self.checkBox];
    [self.checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    self.choiceLabel = [UILabel new];
    self.choiceLabel.textAlignment = NSTextAlignmentLeft;
    self.choiceLabel.font = kYbsFontCustom(15);
    self.choiceLabel.numberOfLines = 0;
    self.choiceLabel.text = @"啊哈哈哈哈哈哈哈哈哈";
    [self.contentView addSubview:self.choiceLabel];
    [self.choiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.checkBox);
        make.left.equalTo(self.checkBox.mas_right).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-20);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCheckBox:(BOOL)choosed{
    
    if (choosed) {
        self.checkBox.image = kImageNamed(@"choice_selected");
//        [self.checkBox setImage:kImageNamed(@"choice_selected") forState:UIControlStateNormal];
    }else{
        self.checkBox.image = kImageNamed(@"choice_nor");
//        [self.checkBox setImage:kImageNamed(@"choice_nor") forState:UIControlStateNormal];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
