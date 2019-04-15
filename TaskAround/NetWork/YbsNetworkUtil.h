//
//  YbsNetworkUtil.h
//  TaskAround
//
//  Created by xinguang hu on 2019/1/17.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YbsNetworkUtil : NSObject

+ (instancetype)shareInstance;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
//- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id responseObject))success
                       failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
