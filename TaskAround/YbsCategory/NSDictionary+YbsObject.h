//
//  NSDictionary+YbsObject.h
//  TaskAround
//
//  Created by xinguang hu on 2019/3/5.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (YbsObject)

+ (NSDictionary *)getObjectData:(id)obj;
- (NSDictionary *)convertNullValueToEmptyStr;
+ (NSDictionary *)readLocalJsonFileWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
