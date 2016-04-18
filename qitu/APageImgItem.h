//
//  APageImgItem.h
//  qitu
//
//  Created by 上海企图 on 16/4/7.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APageImgItem : NSObject
@property (nonatomic, assign) NSInteger imgWidth;
@property (nonatomic, assign) NSInteger img_x;
@property (nonatomic, assign) NSInteger img_y;
@property (nonatomic, strong) NSString *imgStr;
@property (nonatomic,strong) NSString *bgColor;
@property (nonatomic, strong) NSString *type;
@end
