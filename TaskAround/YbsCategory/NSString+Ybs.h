//
//  NSString+Ybs.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/18.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline NSString *stringify(id object){
    if([object isEqual:[NSNull null]] || object == nil || object == NULL){
        return @"";
    }else if ([object isKindOfClass:NSString.class]){
        return [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return [NSString stringWithFormat:@"%@",object];
}

static inline NSString *formatString(NSString *format,...){
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return string;
}

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Ybs)

- (BOOL)isEmpty;

- (BOOL)isAllNumber;

- (BOOL)isAllNumberOrDecimal;

- (BOOL)isPhoneNumber;

- (BOOL)isAmount;

- (BOOL)isIDCard;

- (BOOL)isNumberOrAlphabetOrChinese;

- (NSString *)trimBlank;

+ (NSString *)md5:(NSString *)str;

+ (NSString *)randomStringWithLength:(NSInteger)length;



@end

NS_ASSUME_NONNULL_END
