//
//  QTAPIClient+User.h
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "QTAPIClient.h"
#import "UserInfoItem.h"
@interface QTAPIClient (User)
/**
 *  用户注册
 *
 *  @param mobile   手机号
 *  @param password 密码
 */
- (void)registerWithMobile:(NSString *)mobile password:(NSString *)password;

/**
 *  用户登录
 *
 *  @param mobile   手机号
 *  @param password 密码
 */
- (UserInfoItem *)loginWithMobile:(NSString *)mobile password:(NSString *)password;

/**
 *  忘记密码
 *
 *  @param mobile 手机号
 */
- (void)forgetPasswordWithMobile:(NSString *)mobile;

/**
 *  用户信息
 */
- (void)userInfo;

/**
 *  修改用户信息
 *
 *  @param key   字段
 *  @param value 值
 */
- (void)updateUserInfoWithKey:(NSString *)key value:(NSString *)value;
@end
