//
//  NSObject+HHProperty.h
//  HHProperty
//
//  Created by 豫风 on 2017/12/22.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DEEPLEVEL 3//查找类的层级数


@interface NSObject (HHProperty)

/**
 快速生成模型属性
 
 @param sources    数组或字典
 @para  map        替换字段映射
 @para  container  映射对象
 */
+ (void)generateProperty:(id)sources;
+ (void)generateProperty:(id)sources map:(NSDictionary *)map;
+ (void)generateProperty:(id)sources map:(NSDictionary *)map container:(NSDictionary <NSString *,Class>*)container;


/**
 方法交换

 @param source 源方法
 @param destination 目的方法
 */
+ (void)hh_swizzleMethodSource:(SEL)source destination:(SEL)destination;

@end
