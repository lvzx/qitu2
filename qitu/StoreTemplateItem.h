//
//  StoreTemplateItem.h
//  qitu
//
//  Created by 上海企图 on 16/3/29.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreTemplateItem : NSObject
@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) float price;
@property (assign, nonatomic) NSInteger discount;
@property (assign, nonatomic) NSInteger sale_number;
@property (copy, nonatomic) NSString *firstImg;
@property (copy, nonatomic) NSString *QRcodeImg;
@end
