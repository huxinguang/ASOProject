//
//  TaskListAudioDetailView.h
//  PatchedTogetherTask
//
//  Created by xinguang hu on 2018/6/11.
//  Copyright © 2018年 chenjianlin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YbsQueModel.h"
#import "YbsTaskModel.h"

typedef void(^AudioRecordChooseBlock)(YbsVoiceModel *);

@interface YbsAudioRecordView : UIView
@property (nonatomic, copy  ) NSString *pathStr; // 保存路径
@property (nonatomic, copy  ) AudioRecordChooseBlock chooseBlock;

- (instancetype)initWithVoiceModel:(YbsVoiceModel *)vModel
                      quetionModel:(YbsQueModel *)qModel
                         taskModel:(YbsTaskModel *)tModel
                       chooseBlock:(AudioRecordChooseBlock)block;

- (void)show;
- (void)dismiss;

@end
