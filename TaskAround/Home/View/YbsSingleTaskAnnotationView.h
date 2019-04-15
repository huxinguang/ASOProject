//
//  YbsSingleTaskAnnotationView.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/25.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsSingleTaskAnnotationView : MAAnnotationView
@property (nonatomic, strong) UIImageView *annotationImageView;
@property (nonatomic, strong) UILabel *annotationTitleLabel;
@end

NS_ASSUME_NONNULL_END
