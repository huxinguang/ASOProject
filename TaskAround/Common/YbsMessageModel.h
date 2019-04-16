//
//  YbsMessageModel.h
//  TaskAround
//
//  Created by xinguang hu on 2019/4/11.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsMessageModel : NSObject

@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *hasRead;
//@property (nonatomic, copy) NSString *openType;
//@property (nonatomic, copy) NSString *openUrl;
@property (nonatomic, copy) NSString *createTime;

@end

NS_ASSUME_NONNULL_END
