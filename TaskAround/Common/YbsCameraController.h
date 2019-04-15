//
//  YbsCameraController.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/20.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsBaseViewController.h"
#import "YbsTaskModel.h"
#import "YbsQueModel.h"

typedef void(^CameraBlock)(NSArray *);

@interface YbsCameraController : YbsBaseViewController

@property (nonatomic, strong) YbsTaskModel *taskModel;
@property (nonatomic, strong) YbsQueModel *questionModel;
@property (nonatomic, assign) NSInteger initialCount;
@property (nonatomic, copy  ) CameraBlock cameraBlock;
@property (nonatomic, assign) BOOL needWatermark;

@end
