//
//  QTAPIClient+User.m
//  qitu
//
//  Created by 上海企图 on 16/3/17.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "QTAPIClient+User.h"

@implementation QTAPIClient (User)
- (void)registerWithMobile:(NSString *)mobile password:(NSString *)password {

}

- (UserInfoItem *)loginWithMobile:(NSString *)mobile password:(NSString *)password {
    UserInfoItem * __block user = nil;
    NSDictionary *dic = @{@"email":@"250176996@qq.com", @"password":@"bnfSJ27JLq/CCnUHH68YQg==", @"timestamp":@"1458616475750"};
    [self POST:kLogin parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        NSDictionary *data = responseObject[@"data"];
        self.token = data[@"token"];
        self.uid = [data[@"uid"] integerValue];
        user = [UserInfoItem mj_objectWithKeyValues:data];
        NSLog(@"responseObject:%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
    return user;
}

- (void)forgetPasswordWithMobile:(NSString *)mobile {

}

- (void)userInfo {

}

- (void)updateUserInfoWithKey:(NSString *)key value:(NSString *)value {

}

@end
