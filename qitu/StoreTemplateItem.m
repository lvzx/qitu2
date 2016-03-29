//
//  StoreTemplateItem.m
//  qitu
//
//  Created by 上海企图 on 16/3/29.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "StoreTemplateItem.h"

@implementation StoreTemplateItem
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}
@end
