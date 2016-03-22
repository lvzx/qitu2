//
//  QTAPIClient.h
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface QTAPIClient : AFHTTPSessionManager
/**
 *  访问token
 */
@property (copy, nonatomic) NSString *token;
/**
 *  用户Id
 */
@property NSInteger uid;

+ (instancetype)sharedClient;

@end
