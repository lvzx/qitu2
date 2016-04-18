//
//  APageImgItem.m
//  qitu
//
//  Created by 上海企图 on 16/4/7.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageImgItem.h"

@implementation APageImgItem
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"imgWidth" : @"width",
             @"img_x" : @"x",
             @"img_y" : @"y",
             @"imgStr" : @"resources",
             @"bgColor" : @"bgcolor"
             };
}
@end
