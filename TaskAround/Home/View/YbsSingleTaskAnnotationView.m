//
//  YbsSingleTaskAnnotationView.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/25.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsSingleTaskAnnotationView.h"

@interface YbsSingleTaskAnnotationView ()



@end

@implementation YbsSingleTaskAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.bounds = CGRectMake(0, 0, 34.5, 42.5);
        [self buildSubViews];
    }
    return self;
}

- (void)buildSubViews{
    self.image = nil;
    self.canShowCallout = NO;
    self.centerOffset = CGPointMake(0, -42.5);
    self.annotationImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    self.annotationImageView.image = kImageNamed(@"task_single");
    [self addSubview:self.annotationImageView];

    self.annotationTitleLabel = [UILabel new];
    self.annotationTitleLabel.textColor = kColorHex(@"#FE9901");
    self.annotationTitleLabel.numberOfLines = 1;
    self.annotationTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.annotationTitleLabel.minimumScaleFactor = 0.5;
    self.annotationTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.annotationTitleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:self.annotationTitleLabel];
    
    [self.annotationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(3);
        make.right.equalTo(self).with.offset(-3);
        make.center.equalTo(self).with.centerOffset(CGPointMake(0, -5));
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
