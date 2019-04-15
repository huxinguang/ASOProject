//
//  YbsAnswerModel.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/5.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YbsAnswerItem;

@interface YbsAnswerModel : NSObject

@property (nonatomic, copy  ) NSString *taskId;
@property (nonatomic, copy  ) NSString *storeId;
@property (nonatomic, strong) NSMutableArray<YbsAnswerItem *> *answerList;
@property (nonatomic, copy  ) NSString *type;                           //是否为立即提交 0 否 1 是
@property (nonatomic, copy  ) NSString *stayId;                         //稍后提交id


@end

NS_ASSUME_NONNULL_END

@class YbsAnswerContent;

@interface YbsAnswerItem : NSObject

@property (nonatomic, copy  ) NSString *qid;
@property (nonatomic, copy  ) NSString *type;                           // 问题类型
@property (nonatomic, strong) YbsAnswerContent *content;

@end


@class YbsImgRemark;

@interface YbsAnswerContent : NSObject

@property (nonatomic, copy  ) NSString *text;
@property (nonatomic, strong) NSNumber *choice;
@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, strong) NSMutableArray<YbsImgRemark *> *imgRemarks;
@property (nonatomic, strong) NSMutableArray *audios;

@end

@interface YbsImgRemark : NSObject

@property (nonatomic, copy  ) NSString *img;
@property (nonatomic, copy  ) NSString *remark;

@end
