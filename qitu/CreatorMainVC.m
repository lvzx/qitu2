//
//  CreatorMainVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/26.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "CreatorMainVC.h"
#import "BuyTemplateMainVC.h"


#define kContentH kScreenHeight-64-50
@interface CreatorMainVC ()<UIScrollViewDelegate>
{
    UIImageView *navTitleImgV;
}
@property (strong, nonatomic) UITableView *leftTableView;
@property (strong, nonatomic) BuyTemplateMainVC *rightVC;
@end

@implementation CreatorMainVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavAndView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UI
- (void)initNavAndView {
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 180, 40)];
    navTitleImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 180, 29)];
    navTitleImgV.image = [UIImage imageNamed:@"maka_mubanstore_buy"];
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    btnLeft.tag = 20;
    [btnLeft addTarget:self action:@selector(toucuUpInside:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(90, 0, 90, 40)];
    btnRight.tag = 21;
    [btnRight addTarget:self action:@selector(toucuUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [navTitleView addSubview:navTitleImgV];
    [navTitleView addSubview:btnLeft];
    [navTitleView addSubview:btnRight];
    [self.navigationItem setTitleView:navTitleView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kContentH)];
    _rightVC = [[BuyTemplateMainVC alloc] init];
    [self.mainScrollView addSubview:_leftTableView];
    [self.mainScrollView addSubview:_rightVC.view];
    
    self.mainScrollView.contentSize = CGSizeMake(2*kScreenWidth, kContentH);
}



#pragma mark - Action
- (void)toucuUpInside:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 20:
        {
        
        }
            break;
        case 21:
        {
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - UIScrollViewDelegate



@end
