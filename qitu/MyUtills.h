//
//  MyUtills.h
//  qitu
//
//  Created by 上海企图 on 16/3/24.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUtills : NSObject
//添加边框
+ (void)setViewBorder:(UIView *)aView;
//添加边框及圆角
+ (void)setViewBorderAndCorner:(UIView *)aView;
//将视图变成圆形
+ (void)roundedView:(UIView *)aView;
//UITextView加完成按钮
+ (void)addDoneToKeyboardWith:(UIView *)activeView Handler:(id)obj withResignAction:(SEL)selector;
//获取UIlabel高度
+ (CGSize)boundingRectText:(NSString *)str WithFont:(UIFont *)font WithSize:(CGSize)size;
//相册读取
+ (void)showImagePicker:(id)delegate view:(UIViewController*)controller;
//相册读取及照相
+ (void)showCamera:(id)delegate view:(UIViewController*) controller allowsEditing:(BOOL)allow;
//调整图片角度
+ (UIImage *)changeImageOrientation:(UIImage *)image;
+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date;      //date为空时返回的是当前年月日
//+ (void)formatLbl1:(UILabel *) lab1 withLab2:(UILabel *) lab2;
////设置不同字体颜色
//+ (void)fuwenbenLabel:(UILabel *)label fontNumber:(id)font andRange:(NSRange)range andColor:(UIColor *)vaColor;

#pragma mark - Common Function

+ (NSString *)getDeviceTokenFromData:(NSData *)deviceToken;     //获取APNS设备令牌

+ (void)showAppCommentWithAppID:(int)appID;                     //显示AppStore应用评论
+ (void)call:(NSString *)telephoneNum;                          //拨打电话
+ (void)sendSMS:(NSString *)telephoneNum;                       //发送短信
+ (void)sendEmail:(NSString *)emailAddr;                        //发送邮件
+ (void)openUrl:(NSString *)url;                                //打开网页

+ (NSStringEncoding)getGBKEncoding;                             //获得中文gbk编码

@end
