//
//  SettingsVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/23.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "SettingsVC.h"
#import "MyUtills.h"
#import "UserDetailItem.h"
#import "PersonalInfoVC.h"

@interface SettingsVC ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *listArr;
    float cacheSize;//缓存内容大小
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLbl;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;
@property (strong, nonatomic) UserDetailItem *userDetail;
@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    listArr = @[@[@"余额", @"账号安全"],@[@"新手指导"], @[@"意见反馈", @"关于企图"], @[@"分享账号绑定"], @[@"清理缓存"]];
    //文件保存地址
    //NSString *folderPath =
    cacheSize = [MyUtills folderSizeAtPath:@""];
    [self initNavAndView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getUserDetailNet];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPersonalInfo"]) {
        PersonalInfoVC *personalInfoVC = segue.destinationViewController;
        personalInfoVC.userDetail = self.userDetail;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavAndView {
    [self setNavTitle:@"设置"];
    [self setNavBackBarSelector:@selector(navBack)];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [MyUtills roundedView:_avatarImg];
    self.userAccountLbl.text = self.email;
    self.nickNameLbl.text = [self.nickname length] > 0 ? _nickname : @"未设置";
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network
- (void)getUserDetailNet {
    QTAPIClient *QTClient = [QTAPIClient sharedClient];
    NSInteger interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *url = [NSString stringWithFormat:@"%@/%@", kGetUserInfo, @(QTClient.uid)];
    NSDictionary *param = @{@"timestamp":@(interval), @"token":QTClient.token, @"uid":@(QTClient.uid)};
    [QTClient GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        NSDictionary *data = responseObject[@"data"];
        self.userDetail = [UserDetailItem mj_objectWithKeyValues:data];
        self.nickNameLbl.text = [self.userDetail.nickname length] > 0 ? _userDetail.nickname : @"未设置";
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listArr[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CommonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    // Configure the cell...
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 0 && row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        NSString *balance = [NSString stringWithFormat:@"余额：RMB¥ %@", @(_userDetail.acountBalance)];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:balance];
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(56, 184, 165) range:NSMakeRange(3,[balance length]-3)];
        cell.textLabel.attributedText = str;
        cell.detailTextLabel.text = @"充值";
        cell.detailTextLabel.textColor = RGBCOLOR(56, 184, 165);
    }else if (section == 4) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = listArr[section][row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@M", @(cacheSize)];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = listArr[section][row];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            if (row == 0) {//充值
                
            }else {//账号安全
            
            }
        }
            break;
        case 1://新手指导
        {
        
        }
            break;
        case 2:
        {
            if (row == 0) {//意见反馈
                
            }else {//关于企图
            
            }
        }
            break;
        case 3://分享账号绑定
        {
            
        }
            break;
        case 4://清理缓存
        {
            NSString *msg = nil;
            if (cacheSize == 0) {
                msg = @"呀！没有东西可以清理了";
            }else {
                msg = @"清理完毕,手机又快活了！";
            }
            [self showToast:msg];
        }
            break;
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = RGBCOLOR(236, 236, 236);
    return footer;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0;
}

@end
