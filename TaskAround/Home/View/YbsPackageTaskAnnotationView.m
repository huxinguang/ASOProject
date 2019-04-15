//
//  YbsPackageTaskAnnotationView.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/25.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsPackageTaskAnnotationView.h"

@interface YbsPackageTaskAnnotationView ()

@end

@implementation YbsPackageTaskAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.bounds = CGRectMake(0, 0, 34.0, 45.0);
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews{
    self.image = nil;
    self.canShowCallout = NO;
    self.centerOffset = CGPointMake(0, -45.0/2);
    self.annotationImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.annotationImageView.image = kImageNamed(@"task_package");
    [self addSubview:self.annotationImageView];
    
    self.annotationTitleLabel = [UILabel new];
    self.annotationTitleLabel.textColor = kColorHex(@"#FF2F29");
    self.annotationTitleLabel.numberOfLines = 1;
    self.annotationTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.annotationTitleLabel.minimumScaleFactor = 0.5;
    self.annotationTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.annotationTitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:self.annotationTitleLabel];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"￥5"];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0,1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(1,str.length-1)];
    self.annotationTitleLabel.attributedText = str;
    
    [self.annotationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(2);
        make.right.equalTo(self).with.offset(-4);
        make.center.equalTo(self).with.centerOffset(CGPointMake(0, -6));
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
