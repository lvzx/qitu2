//
//  BaseViewController.h
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//等待框
- (void)showHud;
- (void)hideHud;
- (void)showWaitingView;
- (void)hideWaitingView;

//配置语言和外观
- (void)setupView;


//Toost
- (void)showHudWithToostTitle:(NSString *)title;

//报告网络错误
- (void)reportNetworkError:(NSError *)error;

- (void)setNavBackBarSelector:(SEL)aSelector;
- (void)setNavLeftBarBtnImg:(UIImage *)img selector:(SEL)aSSelector;
- (void)setNavRightBarBtnImg:(NSString *)imgStr selector:(SEL)aSelector;
- (void)setNavRightBarBtnTitle:(NSString *)title selector:(SEL)aSelector;
- (void)setNavTitle:(NSString *)title;
- (UIBarButtonItem *)getCustomNavBarBtnImgName:(NSString *)imgName title:(NSString *)title selector:(SEL)aSelector;

@end
