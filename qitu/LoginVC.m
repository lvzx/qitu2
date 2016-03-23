//
//  LoginVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/22.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "LoginVC.h"
#import "UserInfoItem.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) UserInfoItem *user;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)loginNetAction {
    NSDictionary *param = @{@"email":@"250176996@qq.com", @"password":@"bnfSJ27JLq/CCnUHH68YQg==", @"timestamp":@"1458616475750"};
    QTAPIClient *QTClient = [QTAPIClient sharedClient];
    [QTClient POST:kLogin parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        NSDictionary *data = responseObject[@"data"];
        QTClient.token = data[@"token"];
        QTClient.uid = [data[@"uid"] integerValue];
        self.user = [UserInfoItem mj_objectWithKeyValues:data];
        
        if (_delegate && [_delegate respondsToSelector:@selector(didPassingUserInfo:)]) {
            [self.delegate didPassingUserInfo:_user];
        }
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

        NSLog(@"responseObject:%@, user:%@", responseObject, @(_user.uid));
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (IBAction)touchUpInside:(UIButton *)sender {
    switch (sender.tag) {
        case 10://登录
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Do something...
                [self loginNetAction];
                                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                });
            });
        }
            break;
        case 11://忘记密码？
        {
            
        }
            break;
        case 12://我要注册
        {
            
        }
            break;
        case 13://关闭
        {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
@end
