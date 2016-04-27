//
//  DiyBottomBar.h
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyRelatedEnum.h"

@protocol DiyBottomBarDelegate
- (void)didSelectDiyBottomBtn:(UIButton *)btn;//btn.tag 由 40 开始自增
@end

@interface DiyBottomBar : UIView

@property (assign, nonatomic) ENUM_DIY_TYPE diyBottomType;
- (void)reloadDiyBottom:(ENUM_DIY_TYPE)style;
- (void)setActionHandler:(id)target;
@end
