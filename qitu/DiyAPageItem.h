//
//  DiyAPageItem.h
//  qitu
//
//  Created by 上海企图 on 16/4/7.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APageImgItem.h"
#import "APageTextItem.h"

@interface DiyAPageItem : NSObject
@property (nonatomic, strong) NSMutableArray *imgsMArr;
@property (nonatomic, strong) NSMutableArray *textMArr;
@property (nonatomic, strong) NSString *bgColor;
@property (nonatomic, strong) NSString *bgImgUrl;
@property (nonatomic, assign) NSInteger bgpicwidth;
@property (nonatomic, assign) NSInteger bgpicheight;
@end
