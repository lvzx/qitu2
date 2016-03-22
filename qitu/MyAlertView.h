//
//  MyAlertView.h
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyAlertBlock)(void);

@interface MyAlertView : UIAlertView
/**
 *  未设定代理时，仅做提示的AlertView
 *
 *  @param title       提示标题
 *  @param message     提示消息
 *  @param buttonTitle 确认提示消息按钮
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          buttonTitle:(NSString *)buttonTitle;

/**
 *  用block的方式处理提示内容（但仅限两种提示：取消，确定）
 *
 *  @param title       提示标题
 *  @param message     提示消息
 *  @param cancelTitle 取消提示消息按钮
 *  @param cancelBlock 取消提示要处理的回调方法
 *  @param otherTitle  确认提示消息按钮
 *  @param otherBlock  确认提示要处理的回调方法
 */
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
          cancelTitle:(NSString *)cancelTitle
          cancelBlock:(MyAlertBlock)cancelBlock
           otherTitle:(NSString *)otherTitle
           otherBlock:(MyAlertBlock)otherBlock;
@end
