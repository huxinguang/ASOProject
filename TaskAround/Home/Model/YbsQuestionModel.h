//
//  YbsQuestionModel.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/31.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

//问题类型 0.图片题 1.图片备注题 2.录音题 3.文本题 4.文字描述题 5,单选题 6,多选题

//typedef NS_ENUM(NSInteger,QuestionType) {
//    QuestionTypePicture,                // 图片题
//    QuestionTypeTextPicture,            // 文本+图片题
//    QuestionTypeVoice,                  // 声音题
//    QuestionTypeTextInput,              // 文本输入题
//    QuestionTypeDirection,              // 说明题（文本/文本+图片），无需作答
//    QuestionTypeSingleChoice,           // 单选题
//    QuestionTypeMultipleChoice          // 多选题
//};

NS_ASSUME_NONNULL_BEGIN


@interface YbsQuestionModel : NSObject<NSCoding>



//原始数据部分
@property (nonatomic, copy  ) NSString *question_id;
@property (nonatomic, copy  ) NSString *taskId;
@property (nonatomic, copy  ) NSString *qid;
@property (nonatomic, copy  ) NSString *title;
//@property (nonatomic, assign) QuestionType type;
@property (nonatomic, copy  ) NSString *mustAnswer;
@property (nonatomic, copy  ) NSString *oneOrMore;
@property (nonatomic, copy  ) NSString *uploadLeast;
@property (nonatomic, copy  ) NSString *choiceMin;
@property (nonatomic, copy  ) NSString *choiceMax;
@property (nonatomic, copy  ) NSString *exportType;
@property (nonatomic, copy  ) NSString *textQuestionType;
@property (nonatomic, copy  ) NSString *shopWatermark;
@property (nonatomic, copy  ) NSString *timeWatermark;
@property (nonatomic, copy  ) NSString *positionWatermark;
@property (nonatomic, strong) NSArray *choices;
@property (nonatomic, strong) NSArray *examplePictures;
@property (nonatomic, strong) NSArray *exampleVoices;

//用户作答部分
@property (nonatomic, strong) NSMutableArray *answerPictures;                          //图片题答案
@property (nonatomic, strong) NSMutableArray *answerPicAssetIds;                //图片标识数组
@property (nonatomic, strong) NSMutableArray *answerVoices;                            //语音题答案
@property (nonatomic, strong) NSMutableArray *answerChioces;                           //选择题答案
@property (nonatomic, copy  ) NSString *answerString;                           //文字题答案
@property (nonatomic, strong) NSMutableArray <NSMutableDictionary *> *answerTextPics;  //图片备注题答案








@end

NS_ASSUME_NONNULL_END







