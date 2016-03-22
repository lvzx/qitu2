//
//  MyEventVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/18.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "MyEventVC.h"
#import "MyEventCell.h"
#import "QTAPIClient+User.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define NAV_HEIGHT_DELTA    100.0
#define AVATAR_HEIGHT_DELTA    30.0
#define VERTICAL_STYLE_CHANGE   140.0
@interface MyEventVC ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL isLogin;
    UserInfoItem *user;
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
    [btn addTarget:self action:@selector(personalInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    self.navBar = self.navigationController.navigationBar;
    self.navBar.hidden = YES;
    self.avatarImgV.layer.cornerRadius = self.avatarWidthCons.constant/2.0;
    self.avatarImgV.layer.masksToBounds = YES;
    //取消scrollView默认的内边距64px
    //self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginAction)];
    [self.avatarImgV addGestureRecognizer:avatarTap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (user.uid) {
        NSLog(@"uid:%@", @(user.uid));
        [self updateUIWithData];
    }else {

    }
}

- (void)updateUIWithData {
    [self.avatarImgV sd_setImageWithURL:[NSURL URLWithString:user.thumb] placeholderImage:[UIImage imageNamed:@"maka_avatar_default"]];
    self.nameLbl.text = [user.nickname length] > 0 ? user.nickname : @"未设置";
}

- (void)loginAction {
    user = [[QTAPIClient sharedClient] loginWithMobile:nil password:nil];
    
}

- (void)personalInfo {

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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MyEventCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MyEventCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenWidth/2;
}

@end
