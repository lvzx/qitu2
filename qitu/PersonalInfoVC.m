//
//  PersonalInfoVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/24.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "MyUtills.h"
#import "UserDetailItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PersonalInfoVC ()

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarimgV;
@property (strong, nonatomic) UserDetailItem *userDetail;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *trueName;
@property (weak, nonatomic) IBOutlet UITextField *websiteTF;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *industryLbl;
@end
@implementation PersonalInfoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavAndView];
    [self getUserDatailNet];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
- (void)initNavAndView {
    [self setNavTitle:@"个人资料"];
    [self setNavBackBarSelector:@selector(navBack)];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.exitBtn.layer.cornerRadius = 3.0;
    [MyUtills roundedView:_avatarimgV];
}

- (void)updateUI {
    [self.avatarimgV sd_setImageWithURL:[NSURL URLWithString:_userDetail.thumb] placeholderImage:[UIImage imageNamed:@"maka_avatar_default"]];
    self.nickNameTF.text = _userDetail.nickname;
    self.companyTF.text = _userDetail.company;
    self.trueName.text = _userDetail.truename;
    self.websiteTF.text = _userDetail.mobile;
    self.cityLbl.text = [_userDetail.city length] > 0 ? _userDetail.city : @"未设置";
    self.industryLbl.text = [_userDetail.industry length] > 0 ? _userDetail.industry : @"未设置";
}
#pragma mark - Action
- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectAvatarImg:(id)sender {
    
}
- (IBAction)selectCitys:(id)sender {
    
}
- (IBAction)selectIndustry:(id)sender {
    
}

#pragma mark - Network
- (void)getUserDatailNet {
    QTAPIClient *QTClient = [QTAPIClient sharedClient];
    NSInteger interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *url = [NSString stringWithFormat:@"%@/%@", kGetUserInfo, @(QTClient.uid)];
    NSDictionary *param = @{@"timestamp":@(interval), @"token":QTClient.token, @"uid":@(QTClient.uid)};
    [QTClient GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        NSDictionary *data = responseObject[@"data"];
        self.userDetail = [UserDetailItem mj_objectWithKeyValues:data];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end
