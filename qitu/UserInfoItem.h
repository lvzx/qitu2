//
//  UserInfoItem.h
//  qitu
//
//  Created by 上海企图 on 16/3/22.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoItem : NSObject
@property (assign, nonatomic) NSInteger uid;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *thumb;
@property (assign, nonatomic) NSInteger accountBalance;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) NSInteger templateNumber;
@end
