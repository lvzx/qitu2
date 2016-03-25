//
//  UserDetailItem.h
//  qitu
//
//  Created by 上海企图 on 16/3/25.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetailItem : NSObject
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *thumb;
@property (copy, nonatomic) NSString *company;
@property (copy, nonatomic) NSString *truename;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *industry;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) NSInteger templateNumber;
@end
