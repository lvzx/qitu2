//
//  APageTextItem.m
//  qitu
//
//  Created by 上海企图 on 16/4/7.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageTextItem.h"

@implementation TextItem
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"txtColorHexStr" : @"textColor",
             @"txtAlign" : @"textAlign",
             @"fontSize" : @"textSize"
             };
}
@end

@implementation APageTextItem
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"txt_x" : @"x",
             @"txt_y" : @"y",
             @"txt_width" : @"width",
             @"txt_url" : @"url",
             @"textItem" : @"text"
             };
}
@end
