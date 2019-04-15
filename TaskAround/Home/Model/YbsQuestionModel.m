//
//  YbsQuestionModel.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/31.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsQuestionModel.h"

@implementation YbsQuestionModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"question_id":@"id"
             };
}

//
//+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
//
//    return @{
//             @""
//             }
//}


// 归档
- (void)encodeWithCoder:(NSCoder *)coder{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [coder encodeObject:value forKey:key];
    }
    free(ivars);
}

// 解档
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i<count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [coder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}


- (NSMutableArray *)answerChioces{
    if (!_answerChioces) {
        _answerChioces = [NSMutableArray array];
    }
    return _answerChioces;
}

- (NSMutableArray *)answerPictures{
    if (!_answerPictures) {
        _answerPictures = [NSMutableArray array];
    }
    return _answerPictures;
}

- (NSMutableArray *)answerVoices{
    if (!_answerVoices) {
        _answerVoices = [NSMutableArray array];
    }
    return _answerVoices;
}

-(NSMutableArray *)answerPicAssetIds{
    if (!_answerPicAssetIds) {
        _answerPicAssetIds = [NSMutableArray array];
    }
    return _answerPicAssetIds;
}

- (NSMutableArray<NSMutableDictionary *> *)answerTextPics{
    if (!_answerTextPics) {
        _answerTextPics = [NSMutableArray array];
    }
    return _answerTextPics;
}

-(NSString *)answerString{
    if (!_answerString) {
        _answerString = @"";
    }
    return _answerString;
}



@end
