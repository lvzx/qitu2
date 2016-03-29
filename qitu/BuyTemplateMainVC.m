//
//  BuyTemplateMainVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/28.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "BuyTemplateMainVC.h"
#import "QTSlideBtnView.h"
#import "QTBigScrollView.h"

#define kContentH kScreenHeight-64-50

@implementation BuyTemplateMainVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kContentH);
    [self confingSlideBtnView];
}

- (void)confingSlideBtnView
{
    //NSArray *titleArr = @[@"英语",@"数学",@"语文",@"历史",@"地理",@"思想政治",@"化学",@"物理",@"体育",@"生物",@"音乐",@"美术"];
    
    QTSlideBtnView *s = [[QTSlideBtnView alloc] initWithcontroller:self TitleArr:_categoryArr];
    QTBigScrollView *b = [[QTBigScrollView alloc] initWithcontroller:self TitleArr:_categoryArr];
    
    __weak typeof(s) Sweak = s;
    __weak typeof(b) Bweak = b;
    b.Bgbolck = ^(NSInteger index){
        [Sweak setSBScrollViewContentOffset:index];
    };
    s.sbBlock = ^(NSInteger index){
        [Bweak setBgScrollViewContentOffset:index];
    };
}

@end
