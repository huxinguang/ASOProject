//
//  TTRuntime.h
//  TianTianWang
//
//  Created by yitailong on 16/11/10.
//  Copyright © 2016年 oyxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTRuntime : NSObject

+ (void)exchangeImplementationsWithClass:(Class)clazz
              fromInstanceMethodSelector:(SEL)fromSEL
                toInstanceMethodSelector:(SEL)toSEL;

+ (void)exchangeImplementationsWithClass:(Class)clazz
                 fromClassMethodSelector:(SEL)fromSEL
                   toClassMethodSelector:(SEL)toSEL;

@end
