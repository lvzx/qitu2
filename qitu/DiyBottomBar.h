//
//  DiyBottomBar.h
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ENUM_DIYBACKGROUND,
    ENUM_DIYTEXT,
    ENUM_DIYIMAGE
}ENUM_DIYBOTTOMTYPE;

typedef enum {
    ENUM_DIYBOTTOM_FIRST,
    ENUM_DIYBOTTOM_SECOND,
    ENUM_DIYBOTTOM_THIRD
}ENUM_DIYBOTTOM_ACTIONINDEX;

@protocol DiyBottomBarDelegate
- (void)didSelectDiyBottomBtn:(UIButton *)btn;
@end

@interface DiyBottomBar : UIView

@property (assign, nonatomic) ENUM_DIYBOTTOMTYPE diyBottomType;
- (void)reloadDiyBottom:(ENUM_DIYBOTTOMTYPE)style;
- (void)setActionHandler:(id)target;
@end
