//
//  TTRuntime.m
//  TianTianWang
//
//  Created by yitailong on 16/11/10.
//  Copyright © 2016年 oyxc. All rights reserved.
//

#import "TTRuntime.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation TTRuntime

+ (void)exchangeImplementationsWithClass:(Class)clazz
              fromInstanceMethodSelector:(SEL)fromSEL
                toInstanceMethodSelector:(SEL)toSEL
{
    NSAssert([clazz instancesRespondToSelector:fromSEL], @"not responds to selector is %@", NSStringFromSelector(fromSEL));
    NSAssert([clazz instancesRespondToSelector:toSEL], @"not responds to selector is %@",  NSStringFromSelector(toSEL));
    
    Method fromMethod = class_getInstanceMethod(clazz, fromSEL);
    Method toMethod = class_getInstanceMethod(clazz, toSEL);
    
    method_exchangeImplementations(fromMethod, toMethod);
}

+ (void)exchangeImplementationsWithClass:(Class)clazz
                 fromClassMethodSelector:(SEL)fromSEL
                   toClassMethodSelector:(SEL)toSEL
{
    NSAssert([clazz respondsToSelector:fromSEL],
             @"not responds to selector is %@", NSStringFromSelector(fromSEL));
    NSAssert([clazz respondsToSelector:toSEL],
             @"not responds to selector is %@", NSStringFromSelector(toSEL));
    
    Method fromMthod = class_getClassMethod(clazz, fromSEL);
    Method toMethods = class_getClassMethod(clazz, toSEL);
    
    method_exchangeImplementations(fromMthod, toMethods);
}
@end
