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
- (void)didSelectDiyBottomBtn:(ENUM_DIYBOTTOM_ACTIONINDEX)index;
@end

@interface DiyBottomBar : UIView

@property (assign, nonatomic) ENUM_DIYBOTTOMTYPE diyBottomType;

@end
