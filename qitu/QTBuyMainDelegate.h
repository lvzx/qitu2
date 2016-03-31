//
//  QTBuyMainDelegate.h
//  qitu
//
//  Created by 上海企图 on 16/3/31.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StoreTemplateItem;

@protocol QTBuyMainDelegate <NSObject>
- (void)revealNavPush:(StoreTemplateItem *)item;
@end
