//
//  QTBuyMainView.m
//  qitu
//
//  Created by 上海企图 on 16/3/28.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "QTBuyMainView.h"
#import "QTAPIClient.h"
#import "StoreTemplateCell.h"
#import "MJRefresh.h"

@interface QTBuyMainView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    CGFloat cellW;
    CGFloat cellH;
    NSInteger pageNum;
}
/**
 *  mycollectionView 可以根据自己需求替换成自己的视图.
 */
@property (nonatomic, strong) UICollectionView *mycollectionView;

@property (nonatomic, strong) NSMutableArray *collectionArr;

@end

@implementation QTBuyMainView
-(instancetype)initWithFrame:(CGRect)frame categoryId:(NSInteger)catId
{
    self = [super initWithFrame:frame];
    if (self) {
        self.categoryId = catId;
        [self confingSubViews];
        cellW = (kScreenWidth-15*4)/3;
        cellH = cellW*307/190 + 55;
        [self refreshConfig];
    }
    return self;
}

- (void)confingSubViews
{
    [self addSubview:self.mycollectionView];
}


-(UICollectionView *)mycollectionView
{
    if (_mycollectionView != nil) {
        return _mycollectionView;
    }
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _mycollectionView = [[UICollectionView alloc]initWithFrame:self.frame collectionViewLayout:flowLayout];
    _mycollectionView.delegate = self;
    _mycollectionView.dataSource = self;
    _mycollectionView.showsHorizontalScrollIndicator = NO;
    _mycollectionView.showsVerticalScrollIndicator = NO;
    _mycollectionView.backgroundColor = RGBCOLOR(236, 236, 236);
    [_mycollectionView registerClass:[StoreTemplateCell class] forCellWithReuseIdentifier:@"StoreTemplateCell"];
    return _mycollectionView;
}

- (void)refreshConfig {
    // 下拉刷新
    self.mycollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        pageNum = 0;
        [_collectionArr removeAllObjects];
        [self reloadData];
    }];
    [self.mycollectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.mycollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        pageNum++;
        [self reloadData];
    }];
    // 默认先隐藏footer
    self.mycollectionView.mj_footer.hidden = YES;
}

#pragma mark - Net Action
- (void)getStoreTemplatesByNet {
    NSInteger interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSDictionary *params = @{@"cateId":@(_categoryId), @"pageNumber":@(pageNum), @"perPage":@(20), @"timestamp":@(interval)};
    QTAPIClient *QTClient = [QTAPIClient sharedClient];
    __unsafe_unretained __typeof(self) weakSelf = self;
    [QTClient GET:kGetStoreTemplates parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *data = responseObject[@"data"];
        weakSelf.collectionArr = [StoreTemplateItem mj_objectArrayWithKeyValuesArray:data[@"dataList"]];
        [weakSelf.mycollectionView reloadData];
        // 结束刷新
        [weakSelf.mycollectionView.mj_header endRefreshing];
        [weakSelf.mycollectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
    }];
    
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 设置尾部控件的显示和隐藏
    self.mycollectionView.mj_footer.hidden = _collectionArr.count == 0;
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
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor redColor];
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
        
        [weakSelf.mycollectionView reloadData];
        // 结束刷新
        [weakSelf.mycollectionView.mj_header endRefreshing];
        [weakSelf.mycollectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
        // 结束刷新
        [weakSelf.mycollectionView.mj_header endRefreshing];
        [weakSelf.mycollectionView.mj_footer endRefreshing];
    }];
}

@end
