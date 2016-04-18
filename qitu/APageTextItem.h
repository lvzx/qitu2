//
//  APageTextItem.h
//  qitu
//
//  Created by 上海企图 on 16/4/7.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TextItem : NSObject
@property (nonatomic, strong) NSString *txtColorHexStr;
@property (nonatomic, strong) NSString *txtAlign;
@property (nonatomic, assign) NSInteger fontSize;
@property (nonatomic, strong) NSString *text;
@end

@interface APageTextItem : NSObject
@property (nonatomic, assign) NSInteger txt_x;
@property (nonatomic, assign) NSInteger txt_y;
@property (nonatomic, assign) NSInteger tx_width;
@property (nonatomic, strong) NSString *txt_url;
@property (nonatomic, strong) TextItem *textItem;
 @property (nonatomic, strong) NSString *type;
@end
