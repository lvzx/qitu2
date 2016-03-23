//
//  SettingsVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/23.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()
{
    NSArray *listArr;
}

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    listArr = @[@[@"余额", @"账号安全"],@[@"新手指导"], @[@"意见反馈", @"关于企图"], @[@"分享账号绑定"], @[@"清理缓存"]];
    [self initNavAndView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavAndView {
    [self createUI];
}

- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

#pragma mark - UITableViewDataSource、UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [listArr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (4 == indexPath.row) {
        cell.detailTextLabel.text = @"V5.1.1"; //**版本号更新
    }
    
    return cell;
}

@end
