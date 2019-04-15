//
//  YbsAnswerModel.m
//  TaskAround
//
//  Created by xinguang hu on 2019/3/5.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsAnswerModel.h"

@implementation YbsAnswerModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"answerList" : [YbsAnswerItem class]};
}


@end

@implementation YbsAnswerItem



@end

@implementation YbsAnswerContent

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"imgRemarks" : [YbsImgRemark class]};
}


@end

@implementation YbsImgRemark



@end
