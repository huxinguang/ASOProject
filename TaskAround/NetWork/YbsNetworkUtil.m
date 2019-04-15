//
//  YbsNetworkUtil.m
//  TaskAround
//
//  Created by xinguang hu on 2019/1/17.
//  Copyright © 2019 Yunbangshou. All rights reserved.
//

#import "YbsNetworkUtil.h"
#import "KDCommonMacro.h"
#import "YbsNavigationController.h"
#import "YbsLoginViewController.h"

typedef NSString * (^AFQueryStringSerializationBlock)(NSURLRequest *request, id parameters, NSError *__autoreleasing *error);

@interface YbsNetworkUtil ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

static YbsNetworkUtil *shareUtil = nil;

@implementation YbsNetworkUtil

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareUtil = [[YbsNetworkUtil alloc]init];
    });
    return shareUtil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [AFHTTPSessionManager manager];
        self.manager.requestSerializer.timeoutInterval = 5.0f;
        self.manager.requestSerializer.allowsCellularAccess = YES;
        
        //自定义参数序列化
        AFQueryStringSerializationBlock customQueryStringSerialization = ^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error){
            
            //if ([[[request HTTPMethod] uppercaseString] isEqualToString:@"POST"]) {
                NSDictionary *paramDic = parameters;
                //添加接口签名
                NSString *sortedStr=[self sortedDictionary:paramDic]; //参数拼接+排序
                NSString *md5Str=[NSString md5:sortedStr];
                NSString *upperedStr = [md5Str uppercaseString];
                NSMutableDictionary *mutDic = paramDic.mutableCopy;
                [mutDic setObject:upperedStr forKey:@"sign"];
//                NSString *taskJsonStr=[NSString dictionaryToJson:[mutDic copy]];
                NSString *taskJsonStr = [[mutDic copy] jsonStringEncoded];
            //}
        
            return taskJsonStr;
        };
        //使用KVC来设值
        [self.manager.requestSerializer setValue:customQueryStringSerialization forKey:@"queryStringSerialization"];
        
        //设置Header
        [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                  @"text/html",
                                                                  @"text/json",
                                                                  @"text/javascript",
                                                                  @"text/plain",
                                                                  nil];
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *))failure
{
    NSURLSessionDataTask *dataTask = [self.manager GET:URLString
                                            parameters:parameters
                                              progress:nil
                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        
                                                    if ([stringify(responseObject[@"code"]) isEqualToString:@"0"] || [stringify(responseObject[@"code"]) isEqualToString:@"200"]){
                                                        if(success)success(responseObject);
                                                    }else{
                                                        NSError *error = [NSError errorWithDomain:URLString code:[responseObject[@"code"] integerValue] userInfo:@{@"status":@"request error",@"msg":stringify(responseObject[@"msg"])}];
                                                        if(failure)failure(error);
                                                    }
        
                                               }
                                               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
                                                        if(failure)failure(error);
                                                   
                                               }
                                      ];
    
    return dataTask;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure
{

    NSString *token = @"";
    NSDictionary *dic = kUserDefaultGet(kYbsUserInfoDicKey);
    if (dic) {
        token = dic[@"token"];
    }
    [self.manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [self.manager.requestSerializer setValue:kCurrentTimestampMillisecond forHTTPHeaderField:@"nonceString"];
    [self.manager.requestSerializer setValue:@"1.0.0" forHTTPHeaderField:@"version"];
    
    NSURLSessionDataTask *dataTask = [self.manager POST:URLString
                                             parameters:parameters
                                               progress:nil
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        NSDictionary *dic = responseObject;
        if ([dic[kYbsCodeKey]isEqualToString:kYbsTokenExpired]) {
            kUserDefaultRemove(kYbsUserInfoDicKey);
            kUserDefaultSynchronize;
            
            if (![[UIViewController currentViewController] isKindOfClass:[YbsLoginViewController class]]) {
                YbsLoginViewController *vc = [[YbsLoginViewController alloc]init];
                __weak typeof (vc) weakVc = vc;
                vc.successBlock = ^{
                    [weakVc dismissViewControllerAnimated:YES completion:nil];
                };
                vc.visitorBlock = ^{
                    [weakVc dismissViewControllerAnimated:YES completion:^{
                    }];
                };
                
                UINavigationController *nav = [[YbsNavigationController alloc] initWithRootViewController:vc];
                [[UIViewController currentViewController] presentViewController:nav animated:YES completion:nil];
            }
            
            [SVProgressHUD dismiss];
        }else{
            success(responseObject);
        }
 
    }
                                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if(failure)failure(error);
    }
    ];
    
    return dataTask;
    
}


- (NSString*)sortedDictionary:(NSDictionary *)dict{
    
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1,                                                                          id _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        NSString *arrStr=[NSString stringWithFormat:@"%@=%@",sortsing,valueString];
        [valueArray addObject:arrStr];
    }
    NSString *string = [valueArray componentsJoinedByString:@"&"];
    NSString *str1=[NSString stringWithFormat:@"&key=%@",kYbsMD5Secret];
    NSString *md5Str=[NSString stringWithFormat:@"%@%@",string,str1];
    return md5Str;
}

- (NSMutableDictionary *)mutTodic:(NSDictionary *)dict{
    //将所有的key放进数组
    NSArray *allKeyArray = [dict allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1,
                                                                                             id _Nonnull obj2) {
        NSComparisonResult resuest = [obj1 compare:obj2];
        return resuest;
    }];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    //通过排列的key值获取value
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [dict objectForKey:sortsing];
        
        [dic setValue:valueString forKey:sortsing];
        
    }
    
    return dic;
}


@end
