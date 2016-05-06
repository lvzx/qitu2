//
//  APageTextLabel.h
//  qitu
//
//  Created by 上海企图 on 16/4/18.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APageTextItem.h"
#import "DiyShowDelgate.h"
@class DiyAPageItem;

@interface APageTextLabel : UILabel
@property (nonatomic, strong) DiyAPageItem *pageItem;
@property (assign, nonatomic) NSInteger txtIdx;//此图在textMArr中的索引

@property (nonatomic, strong) APageTextItem *txtItem;
@property (nonatomic, assign) BOOL hasBorder;
@property (assign, nonatomic) id<DiyShowDelgate> myDelegate;

- (void)updatePageTextData;
@end
