//
//  YbsPicTextTableViewCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/19.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsPicTextTableViewCell.h"

#define kMarginLeftRight 10

#define kItemCountAtEachRow 4
#define kMinimumInteritemSpacing 5
#define kMinimumLineSpacing 5

#define kCollectionViewCellHW ((kAppScreenWidth - (kItemCountAtEachRow-1)*kMinimumInteritemSpacing - 2*kMarginLeftRight)/kItemCountAtEachRow)

@implementation YbsPicTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews{
    self.imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgBtn.backgroundColor = [UIColor redColor];
    [self.imgBtn setImage:kImageNamed(@"add") forState:UIControlStateNormal];
    [self.contentView addSubview:self.imgBtn];
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.contentView).with.offset(5);
        make.bottom.equalTo(self.contentView).with.offset(-5);
        make.width.mas_equalTo(kCollectionViewCellHW);
    }];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:kImageNamed(@"selected_delete") forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgBtn).with.offset(3);
        make.right.equalTo(self.imgBtn).with.offset(-3);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.textView = [UITextView new];
    self.textView.xg_placeholder = @"此处是照片描述";
    self.textView.font = kYbsFontCustom(15);
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self.imgBtn);
        make.left.equalTo(self.imgBtn.mas_right).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
