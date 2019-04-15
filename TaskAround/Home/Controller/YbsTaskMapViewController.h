//
//  YbsTaskMapViewController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/21.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsMLBaseViewController.h"
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsTaskMapViewController : YbsMLBaseViewController

@property (nonatomic, strong) MAMapView *mapView;

- (void)refreshButtonClick:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
