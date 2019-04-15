//
//  YbsCameraPreviewVC.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/20.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsBaseViewController.h"
#import "YbsQueModel.h"

@protocol CameraPreviewDelegate <NSObject>

- (void)deletePhotosAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface YbsCameraPreviewVC : YbsBaseViewController

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, weak  ) id <CameraPreviewDelegate> delegate;
@property (nonatomic, strong) YbsQueModel *quetionModel;


@end

NS_ASSUME_NONNULL_END
