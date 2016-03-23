//
//  LoginVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/22.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "LoginVC.h"
#import "QTAPIClient+User.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userAccountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.userAccountTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.passwordTF setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
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
- (IBAction)touchUpInside:(UIButton *)sender {
    switch (sender.tag) {
        case 10://登录
        {
            //user = [[QTAPIClient sharedClient] loginWithMobile:nil password:nil];
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
