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
#import "CategoryItem.h"

@implementation BuyTemplateMainVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kContentH);
    [self getCategoryNetAction];
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

#pragma mark - Net Request
- (void)getCategoryNetAction {
    QTAPIClient *QTClient = [QTAPIClient sharedClient];
    NSInteger interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *url = [NSString stringWithFormat:@"%@?timestamp=%@", kCategoryApp, @(interval)];
    [QTClient GET:url parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSArray *dataArr = responseObject[@"data"];
              self.categoryArr = [CategoryItem mj_objectArrayWithKeyValuesArray:dataArr];
              [self confingSlideBtnView];
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              // 请求失败
              NSLog(@"%@", [error localizedDescription]);
          }];
}

@end
