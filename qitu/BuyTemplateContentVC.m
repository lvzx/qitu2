//
//  BuyTemplateContentVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/30.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "BuyTemplateContentVC.h"
#import "QTAPIClient.h"
#import "StoreTemplateCell.h"
#import "MJRefresh.h"

@interface BuyTemplateContentVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    CGFloat cellW;
    CGFloat cellH;
    NSInteger pageNum;
}
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSMutableArray *collectionArr;
@end

@implementation BuyTemplateContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self confingSubViews];
    cellW = (kScreenWidth-15*4)/3;
    cellH = cellW*307/190 + 55;
    self.collectionArr = [[NSMutableArray alloc] init];
    [self refreshConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionView *)myCollectionView
{
    if (_myCollectionView != nil) {
        return _myCollectionView;
    }
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50) collectionViewLayout:flowLayout];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.backgroundColor = RGBCOLOR(236, 236, 236);
    [_myCollectionView registerClass:[StoreTemplateCell class] forCellWithReuseIdentifier:@"StoreTemplateCell"];
    return _myCollectionView;
}
- (void)confingSubViews
{
    [self.view addSubview:self.myCollectionView];
}
- (void)refreshConfig {
    // 下拉刷新
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 0;
        [self reloadData];
    }];
    [self.myCollectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.myCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNum++;
        [self reloadData];
    }];
    // 默认先隐藏footer
    self.myCollectionView.mj_footer.hidden = YES;
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 设置尾部控件的显示和隐藏
    self.myCollectionView.mj_footer.hidden = _collectionArr.count == 0;
    return [_collectionArr count];
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"StoreTemplateCell";
    StoreTemplateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        //cell = [[StoreTemplateCell alloc] init];
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    NSInteger row = indexPath.row;
    StoreTemplateItem *item = _collectionArr[row];
    [cell initCellWithData:item];
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellW, cellH);
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 12, 0, 12);
}
//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = indexPath.row;
//    StoreTemplateItem *item = _collectionArr[row];
    NSLog(@"选择%ld",indexPath.row);
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

/**
 *  刷新数据
 */
- (void)reloadData
{
    NSInteger interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSDictionary *params = @{@"cateId":@(_categoryId), @"pageNumber":@(pageNum), @"perPage":@(20), @"timestamp":@(interval)};
    QTAPIClient *QTClient = [QTAPIClient sharedClient];
    __unsafe_unretained __typeof(self) weakSelf = self;
    [QTClient GET:kGetStoreTemplates parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject[@"data"];
        if (pageNum == 0) {
            weakSelf.collectionArr = [StoreTemplateItem mj_objectArrayWithKeyValuesArray:data[@"dataList"]];
        }else {
            [weakSelf.collectionArr addObjectsFromArray:[StoreTemplateItem mj_objectArrayWithKeyValuesArray:data[@"dataList"]]];
        }
        
        [weakSelf.myCollectionView reloadData];
        // 结束刷新
        [weakSelf.myCollectionView.mj_header endRefreshing];
        [weakSelf.myCollectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
        // 结束刷新
        [weakSelf.myCollectionView.mj_header endRefreshing];
        [weakSelf.myCollectionView.mj_footer endRefreshing];
    }];
}
@end
