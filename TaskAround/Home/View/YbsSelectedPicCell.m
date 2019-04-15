//
//  YbsSelectedPicCell.m
//  TaskAround
//
//  Created by xinguang hu on 2019/2/18.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsSelectedPicCell.h"

@implementation YbsSelectedPicCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews{
    self.imgView = [UIImageView new];
    self.imgView.backgroundColor = [UIColor redColor];
    
    [self.contentView addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteBtn setImage:kImageNamed(@"selected_delete") forState:UIControlStateNormal];
    [self.contentView addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(3);
        make.right.equalTo(self.contentView).with.offset(-3);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}






@end
