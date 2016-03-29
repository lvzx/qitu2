//
//  CategoryItem.m
//  qitu
//
//  Created by 上海企图 on 16/3/29.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "CategoryItem.h"

@implementation CategoryItem

// 实现这个方法的目的：告诉MJExtension框架模型中的属性名对应着字典的哪个key
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}
@end
