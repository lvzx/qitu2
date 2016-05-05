//
//  AppStyle.h
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#ifndef AppStyle_h
#define AppStyle_h

//----------页面设计相关-------

#define GLOBAL_STATUSBAR_HEIGHT                                                 20.0f
#define GLOBAL_NAVIGATIONBAR_HEIGHT                                             44.0f
#define GLOBAL_TABBAR_HEIGHT                                                    49.0f
#define GLOBAL_NAVTOP_HEIGHT                                                    64.0f

//bodyView背景色
#define GLOBAL_BODYVIEW_BG_COLOR    [UIColor colorWithRed:235/255.0 green:237/255.0 blue:241/255.0 alpha:1]

//导航栏(背景+Title+Button)
#define GLOBAL_NAVIGATIONBAR_BG_COLOR   [UIColor blackColor]

#define GLOBAL_NAVIGATIONBAR_TITLE_FONT                                          [UIFont systemFontOfSize:19]
#define GLOBAL_NAVIGATIONBAR_TITLE_TEXT_COLOR   [UIColor whiteColor]

#define GLOBAL_NAVIGATIONBAR_BUTTON_TITLE_FONT                                   [UIFont systemFontOfSize:15]
#define GLOBAL_NAVIGATIONBAR_BUTTON_TITLE_TEXT_COLOR    [UIColor whiteColor]
#define GLOBAL_NAVIGATIONBAR_BUTTON_TITLE_UNENABLE_TEXT_COLOR   [UIColor colorWithRed:112/255.0 green:168/255.0 blue:255/255.0 alpha:1]


//tabbar标签栏(背景+Title+Button)
#define GLOBAL_TABBAR_BACKGROUND                                                 @"Global_TabBar_background"
#define GLOBAL_TABBAR_ITEM_TITLE_NORMAL_COLOR   [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1]
#define GLOBAL_TABBAR_ITEM_TITLE_SELECTED_COLOR [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]

#define TABBAR_BARITEM_FIRST_ICON                                             @"maka_tabbar_myspace_normal"
#define TABBAR_BARITEM_FIRST_SELECTED                                           @"maka_tabbar_myspace_press"
#define TABBAR_BARITEM_SECOND_ICON                                            @"maka_tabbar_edit_normal"
#define TABBAR_BARITEM_SECOND_SELECTED                                          @"maka_tabbar_edit_press"
#define TABBAR_BARITEM_THIRD_ICON                                             @"maka_tabbar_hot_normal"
#define TABBAR_BARITEM_THIRD_SELECTED                                           @"maka_tabbar_hot_press"
#define TABBAR_BARITEM_FOURTH_ICON                                            @"tab04_icon"
#define TABBAR_BARITEM_FOURTH_SELECTED                                          @"tab04_selected"

//设置app界面字体及颜色

#define kTitleFontLarge              [UIFont boldSystemFontOfSize:19]//一级标题字号
#define kTitleFontMiddle             [UIFont boldSystemFontOfSize:17]//二级标题字号
#define kTitleFontSmall              [UIFont boldSystemFontOfSize:16]//三级标题字号

#define kContentFontLarge            [UIFont systemFontOfSize:24]  //内容部分大字号
#define kContentFontMiddle           [UIFont systemFontOfSize:15]  //内容部分中字号
#define kContentFontSmall            [UIFont systemFontOfSize:14]  //内容部分小字号
#define kContentFontSmaller            [UIFont systemFontOfSize:13]  //内容部分小字号

#define VIEW_BORDERCOLOR   [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1]

#define SEPERAT_LINE_COLOR  @""

//内容部分正常显示颜色和突出显示颜色
#define kContentColorNormal      [UIColor colorWithRed:57/255.0 green:32/255.0 blue:0/255.0 alpha:1]
#define kContentColorHighlight   [UIColor colorWithRed:0/255.0 green:191/255.0 blue:225/255.0 alpha:1]

//几个常用色彩
#define kTitleGrayColor         [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1]
#define kTitleDarkGrayColor     [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]
#define kBlackColor             [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]
#define kRedColor               [UIColor colorWithRed:255/255.0 green:110/255.0 blue:107/255.0 alpha:1]
#define kTitleGreenColor        [UIColor colorWithRed:111/255.0 green:185/255.0 blue:110/255.0 alpha:1]
#define kBgBlueColor            [UIColor colorWithRed:94/255.0 green:163/255.0 blue:238/255.0 alpha:1]
#define kTitleBlueColor         [UIColor colorWithRed:52/255.0 green:112/255.0 blue:183/255.0 alpha:1]
#define kClearColor             [UIColor clearColor]
#define kWhiteColor             [UIColor whiteColor]
#define kAppBgColor             [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]
#define kMainColor              [UIColor colorWithRed:64/255.0 green:168/255.0 blue:174/255.0 alpha:1]

#endif /* AppStyle_h */
