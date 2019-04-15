//
//  YbsQueModel.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/2.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,QuestionType) {
    QuestionTypePicture = 0,            // 图片题
    QuestionTypeTextPicture,            // 文本+图片题
    QuestionTypeVoice,                  // 声音题
    QuestionTypeTextInput,              // 文本输入题
    QuestionTypeDirection,              // 说明题（文本/文本+图片），无需作答
    QuestionTypeSingleChoice,           // 单选题
    QuestionTypeMultipleChoice          // 多选题
};

//NS_ASSUME_NONNULL_BEGIN

@class YbsVoiceModel;
@class YbsQuestionAttribute;
@class YbsQuestionLogic;
@class YbsPicText;

@interface YbsQueModel : NSObject<NSCoding>

@property (nonatomic, copy  ) NSString *qid;
@property (nonatomic, copy  ) NSString *quNo;
@property (nonatomic, copy  ) NSString *taskId;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, copy  ) NSString *exportType;
@property (nonatomic, strong) NSArray  *exampleImgs;
@property (nonatomic, strong) YbsQuestionAttribute *specAttr;
@property (nonatomic, copy  ) NSString *mustAnswer;
@property (nonatomic, strong) NSArray<YbsQuestionLogic *> *logics;


//用户作答部分
@property (nonatomic, strong) NSMutableArray *answerPictures;               //图片题答案
@property (nonatomic, strong) NSMutableArray *answerPicAssetIds;            //图片标识数组
@property (nonatomic, strong) NSMutableArray<YbsVoiceModel *> *answerVoices;            //语音题答案
@property (nonatomic, strong) NSMutableArray *answerChioces;                //选择题答案
@property (nonatomic, copy  ) NSString *answerString;                       //文字题答案
@property (nonatomic, strong) NSMutableArray <YbsPicText *> *answerTextPics;//图片备注题答案


@property (nonatomic, copy  ) NSString *logicPreviousIndex; //逻辑上的“上一题”的下标
@property (nonatomic, strong) NSArray *visibleChoices;      //逻辑上可显示的选项
@property (nonatomic, assign) BOOL needCommitAnswer;        //提交时是否带答案(自定义)




@end


@interface YbsVoiceModel : NSObject

@property (nonatomic, copy  ) NSString *voicePath;
@property (nonatomic, assign) NSTimeInterval timeLength;


@end




//NS_ASSUME_NONNULL_END

@class YbsQuestionChioce;

@interface YbsQuestionAttribute : NSObject

@property (nonatomic, copy  ) NSString *watermark;
@property (nonatomic, copy  ) NSString *positionWatermark;
@property (nonatomic, copy  ) NSString *choiceMin;
@property (nonatomic, copy  ) NSString *choiceMax;
@property (nonatomic, copy  ) NSString *uploadLeast;
@property (nonatomic, copy  ) NSString *uploadFromAlbum;
@property (nonatomic, strong) NSArray<YbsQuestionChioce *> *choices;

@end

@interface YbsQuestionChioce : NSObject

@property (nonatomic, copy  ) NSString *code;
@property (nonatomic, copy  ) NSString *content;

@end


@class YbsLogicCondition;
@class YbsLogicJump;
@interface YbsQuestionLogic : NSObject


@property (nonatomic, strong) NSArray<YbsLogicCondition *> *condition;
@property (nonatomic, strong) YbsLogicJump *jump;

@end


@interface YbsLogicCondition : NSObject

@property (nonatomic, copy  ) NSString *choiceType;
@property (nonatomic, copy  ) NSString *textRule;
@property (nonatomic, copy  ) NSString *textRuleNum1;
@property (nonatomic, copy  ) NSString *textRuleNum2;
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, strong) NSArray  *choices;
@property (nonatomic, copy  ) NSString *qid;

@end


@interface YbsLogicJump : NSObject

@property (nonatomic, copy  ) NSString *jumpToQid;
@property (nonatomic, copy  ) NSString *type;
@property (nonatomic, strong) NSArray *choices;

@end


@interface YbsPicText : NSObject

@property (nonatomic, copy  ) NSString *pic;
@property (nonatomic, copy  ) NSString *text;
@property (nonatomic, strong) NSMutableArray *selectedAssetIds;

@end

