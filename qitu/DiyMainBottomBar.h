//
//  DiyMainBottomBar.h
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ENUM_DIYMAINBOTTOM_FIRST = 30,
    ENUM_DIYMAINBOTTOM_SECOND,
    ENUM_DIYMAINBOTTOM_THIRD,
    ENUM_DIYMAINBOTTOM_FOURTH
}ENUM_DIYMAINBOTTOM_BTNINDEX;

@protocol DiyMainBottomBar
- (void)touchUpInsideOnBtn:(UIButton *)btn;
@end
@interface DiyMainBottomBar : UIView
//@property (assign, nonatomic) id<DiyMainBottomBarDelegate> myDelegate;
@end
