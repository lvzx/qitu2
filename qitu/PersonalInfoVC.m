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

@interface PersonItem : NSObject
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@end

@implementation PersonItem
@end

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
    
    NSArray *dictArr = @[@{@"title":@"昵称", @"content":_userDetail.nickname},
                     @{@"title":@"机构名称", @"content":_userDetail.company},
                     @{@"title":@"姓名", @"content":_userDetail.truename},
                     @{@"title":@"手机", @"content":_userDetail.mobile},
                     @{@"title":@"城市", @"content":_userDetail.city},
                     @{@"title":@"行业", @"content":_userDetail.industry}];
    self.listArr = [PersonItem mj_objectArrayWithKeyValuesArray:dictArr];
    
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
    PersonItem *pItem = _listArr[row];
    cell.textLabel.text = pItem.title;
    cell.detailTextLabel.text = pItem.content;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    PersonItem *pItem = _listArr[row];
//    if (row > 0) {
//        <#statements#>
//    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:pItem.title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}
@end
