//
//  PersonalInfoVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/24.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "MyUtills.h"
#import "PersonalInfoCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PersonalInfoVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgV;
@property (strong, nonatomic) NSArray *listArr;
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
    [MyUtills roundedView:_avatarImgV];
    self.listArr = @[@"昵称", @"机构名称", @"姓名", @"手机", @"城市", @"行业"];
}

- (void)updateUI {
    [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:_userDetail.thumb] placeholderImage:[UIImage imageNamed:@"maka_avatar_default"]];
}
#pragma mark - Action
- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectAvatar:(id)sender {
    
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

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_listArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CommonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = RGBCOLOR(219, 219, 219);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.textColor = RGBCOLOR(219, 219, 219);
    }
    // Configure the cell...
    NSInteger row = indexPath.row;
    cell.textLabel.text = _listArr[row];
    switch (row) {
        case 0:
            cell.detailTextLabel.text = _userDetail.nickname;
            break;
        case 1:
            cell.detailTextLabel.text = _userDetail.company;
            break;
        case 2:
            cell.detailTextLabel.text = _userDetail.truename;
            break;
        case 3:
            cell.detailTextLabel.text = _userDetail.mobile;
            break;
        case 4:
            cell.detailTextLabel.text = _userDetail.city;
            break;
        case 5:
            cell.detailTextLabel.text = _userDetail.industry;
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    
}
@end
