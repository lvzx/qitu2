//
//  DiyRelatedEnum.h
//  qitu
//
//  Created by 上海企图 on 16/4/20.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#ifndef DiyRelatedEnum_h
#define DiyRelatedEnum_h

typedef enum {
    ENUM_DIYBACKGROUND,
    ENUM_DIYTEXT,
    ENUM_DIYIMAGE
}ENUM_DIY_TYPE;

typedef enum {
    ENUM_DIYBOTTOM_FIRST,
    ENUM_DIYBOTTOM_SECOND,
    ENUM_DIYBOTTOM_THIRD
}ENUM_DIYBOTTOM_ACTIONINDEX;

typedef enum {
    ENUM_DIY_TEXTLEFT,
    ENUM_DIY_TEXTMIDDLE,
    ENUM_DIY_TEXTRIGHT
}ENUM_DIY_TEXTALIGN;

typedef enum {
    DIY_SEL_PAGE = 10,
    DIY_SEL_BACKGROUND,
    DIY_SEL_ADDITEM,
    DIY_SEL_TEXTSTYLE
}DIY_SEL_ITEM;
#endif /* DiyRelatedEnum_h */
