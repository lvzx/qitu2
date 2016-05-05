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

@interface APageTextLabel : UILabel
@property (nonatomic, strong) APageTextItem *txtItem;
@property (nonatomic, assign) BOOL hasBorder;
@property (assign, nonatomic) id<DiyShowDelgate> myDelegate;
@end
