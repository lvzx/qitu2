//
//  LoginVC.h
//  qitu
//
//  Created by 上海企图 on 16/3/22.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassingUserInfoDelegate <NSObject>

@optional

- (void)didPassingUserInfo:(id)userInfo;

@end

@interface LoginVC : UIViewController

@property (assign, nonatomic) id<PassingUserInfoDelegate> delegate;//通过代理对象传值

@end
