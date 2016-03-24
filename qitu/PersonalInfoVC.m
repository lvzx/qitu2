//
//  PersonalInfoVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/24.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "PersonalInfoVC.h"
#import "MyUtills.h"

@interface PersonalInfoVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *listArr;
}
@property (weak, nonatomic) IBOutlet UITableView *mytableView;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@end
@implementation PersonalInfoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    listArr = @[@"头像", @"昵称", @"机构名称", @"姓名", @"手机", @"城市", @"行业"];
    [self initNavAndView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavAndView {
    [self setNavTitle:@"个人资料"];
    [self setNavBackBarSelector:@selector(navBack)];
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.exitBtn.layer.cornerRadius = 3.0;
}

- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CommonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.textLabel.textColor = RGBCOLOR(119, 119, 119);
         //修改图片的位置
    }
    
    NSInteger row = indexPath.row;
    cell.textLabel.text = listArr[row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == 0) {
        return 75.0;
    }
    return 50.0;
}
@end
