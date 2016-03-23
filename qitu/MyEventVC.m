//
//  MyEventVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/18.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "MyEventVC.h"
#import "MyEventCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginVC.h"
#import "UserInfoItem.h"
#import "SettingsVC.h"

#define NAV_HEIGHT_DELTA    100.0
#define AVATAR_HEIGHT_DELTA    30.0
#define VERTICAL_STYLE_CHANGE   140.0
@interface MyEventVC ()<UITableViewDataSource, UITableViewDelegate, PassingUserInfoDelegate>
{
    BOOL isLogin;
    NSMutableArray *listMArr;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *customNav;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarLeadingCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopCons;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopCons;
@property (strong, nonatomic) UserInfoItem *user;

@end

@implementation MyEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-16, 0, 40, 40)];
    btn.layer.cornerRadius = 20.0;
    btn.layer.masksToBounds = YES;
    [btn setImage:[UIImage imageNamed:@"maka_avatar_default"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"maka_avatar_default"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(avatarTapAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    self.navBar = self.navigationController.navigationBar;
    self.navBar.hidden = YES;
    self.avatarImgV.layer.cornerRadius = self.avatarWidthCons.constant/2.0;
    self.avatarImgV.layer.masksToBounds = YES;
    //取消scrollView默认的内边距64px
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapAction)];
    [self.avatarImgV addGestureRecognizer:avatarTap];
    
    listMArr = [[NSMutableArray alloc] initWithArray:@[@[@"新手指导"], @[@"意见反馈", @"关于企图"], @[@"分享账号绑定"], @[@"清理缓存"]]];
    [self updateUIWithData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateUIWithData {
    if (_user.uid) {
        [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:_user.thumb] placeholderImage:[UIImage imageNamed:@"maka_avatar_default"]];
        self.nameLbl.text = [_user.nickname length] > 0 ? _user.nickname : @"未设置";
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else {
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.myTableView reloadData];
}

- (void)avatarTapAction {
    UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"MyEvent" bundle:nil];
    if (_user.uid) {
        SettingsVC *settingsVC = [storyboard1 instantiateViewControllerWithIdentifier:@"SettingsVC"];
        [self.navigationController pushViewController:settingsVC animated:YES];
    }else {
        LoginVC *loginVC = [storyboard1 instantiateViewControllerWithIdentifier:@"LoginVC"];
        loginVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        nav.navigationBarHidden = YES;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - PassingUserInfoDelegate
- (void)didPassingUserInfo:(id)userInfo {
    if ([userInfo isKindOfClass:[UserInfoItem class]]) {
        self.user = userInfo;
    }
     [self updateUIWithData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;// 偏移的y值
    self.tableViewTopCons.constant -= yOffset;
    CGFloat tableViewYOffSet = self.tableViewTopCons.constant;
    CGFloat scale = (tableViewYOffSet+20.0)/NAV_HEIGHT_DELTA;
    //NSLog(@"yoffset:%@, tableViewyOffset:%@, scale:%@", @(yOffset), @(tableViewYOffSet), @(scale));
    if (yOffset > 0) {
        if (tableViewYOffSet <= 44.0) {
            self.navBar.hidden = NO;
            self.customNav.hidden = YES;
            self.tableViewTopCons.constant = 0.0;
        }else {
            self.navBar.hidden = YES;
            self.customNav.hidden = NO;
            self.nameLbl.hidden = YES;
            self.avatarWidthCons.constant = 20.0+AVATAR_HEIGHT_DELTA*scale;
            if (tableViewYOffSet < VERTICAL_STYLE_CHANGE){
                self.nameLbl.hidden = YES;
                CGFloat topPadding = (tableViewYOffSet+10.0-_avatarWidthCons.constant)/2.0;
                self.avatarTopCons.constant = topPadding;
                CGFloat leading = kScreenWidth-_avatarWidthCons.constant-tableViewYOffSet/2.0;
                self.avatarLeadingCons.constant = leading;
            }else if (tableViewYOffSet < 280.0) {
                self.nameLbl.hidden = NO;
                self.nameLbl.font = [UIFont systemFontOfSize:8.0*scale];
                CGFloat topPadding = (tableViewYOffSet+20.0*(scale-1.0)-_avatarWidthCons.constant)/2.0;
                self.avatarTopCons.constant = topPadding;
                CGFloat leading = (kScreenWidth-_avatarWidthCons.constant)/2.0;
                self.avatarLeadingCons.constant = leading;
            }else {
                self.tableViewTopCons.constant = 300.0;
            }
        }
    }else {
        
        if (tableViewYOffSet <= 44.0) {
            self.navBar.hidden = NO;
            self.customNav.hidden = YES;
            self.tableViewTopCons.constant = 0.0;
        }else {
            self.navBar.hidden = YES;
            self.customNav.hidden = NO;
            
            self.avatarWidthCons.constant = 20.0+AVATAR_HEIGHT_DELTA*scale;
            
            if (tableViewYOffSet < VERTICAL_STYLE_CHANGE) {
                self.nameLbl.hidden = YES;
                CGFloat topPadding = (tableViewYOffSet+10.0-_avatarWidthCons.constant)/2.0;
                self.avatarTopCons.constant = topPadding;
                CGFloat leading = kScreenWidth-_avatarWidthCons.constant-tableViewYOffSet/2.0;
                self.avatarLeadingCons.constant = leading;
            }else if (tableViewYOffSet <= 280.0){
                self.nameLbl.hidden = NO;
                self.nameLbl.font = [UIFont systemFontOfSize:8.0*scale];
                CGFloat topPadding = (tableViewYOffSet+20.0*(scale-1.0)-_avatarWidthCons.constant)/2.0;
                self.avatarTopCons.constant = topPadding;
                CGFloat leading = (kScreenWidth-_avatarWidthCons.constant)/2.0;
                self.avatarLeadingCons.constant = leading;
            }else {
                self.tableViewTopCons.constant = 300.0;
            }
        }
    }
    self.avatarImgV.layer.cornerRadius = _avatarWidthCons.constant/2.0;
    self.avatarImgV.layer.masksToBounds = YES;
    
    [self.view updateConstraintsIfNeeded];
    [self.view layoutIfNeeded];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [listMArr count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_user.uid) {
        return 2;
    }else{
        return [listMArr[section] count];
    }
    return 0;
}
- (MyEventCell *)tableView:(UITableView *)tableView myEventCellForRow:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyEventCell";
    
    MyEventCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyEventCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView commonCellForRow:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CommonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    // Configure the cell...
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = listMArr[section][row];
   
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (_user.uid) {
        cell = [self tableView:tableView myEventCellForRow:indexPath];
    }
    else {
        cell = [self tableView:tableView commonCellForRow:indexPath];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_user.uid) {
        return kScreenWidth/2;
    }else {
        return 44.0;
    }
    return 0.0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = RGBCOLOR(236, 236, 236);
    return footer;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.0;
}
@end
