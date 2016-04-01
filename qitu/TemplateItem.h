//
//  TemplateItem.h
//  qitu
//
//  Created by 上海企图 on 16/3/31.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneItem : NSObject

@end

@interface TemplateItem : NSObject
@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSArray *imgUrls;//展示模版页面列表
@end
