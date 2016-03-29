//
//  QTBuyMainView.m
//  qitu
//
//  Created by 上海企图 on 16/3/28.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "QTBuyMainView.h"
#import "StoreTemplateCell.h"
#import "StoreTemplateItem.h"

@interface QTBuyMainView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    CGFloat cellW;
    CGFloat cellH;
}
/**
 *  mytableView 可以根据自己需求替换成自己的视图.
 */
@property(nonatomic, strong)UICollectionView *mycollectionView;

@end

@implementation QTBuyMainView
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        [self confingSubViews];
        cellW = (kScreenWidth-15*4)/3;
        cellH = cellW*307/190 + 55;
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
    _mycollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
    _mycollectionView.delegate = self;
    _mycollectionView.dataSource = self;
    _mycollectionView.showsHorizontalScrollIndicator = NO;
    _mycollectionView.showsVerticalScrollIndicator = NO;
    _mycollectionView.backgroundColor = RGBCOLOR(236, 236, 236);
    [_mycollectionView registerClass:[StoreTemplateCell class] forCellWithReuseIdentifier:@"StoreTemplateCell"];
    return _mycollectionView;
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
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
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.imgView.image = [UIImage imageNamed:@"maka_muban_normal"];
    cell.titleLbl.text = [NSString stringWithFormat:@"Cell %ld",indexPath.row];
    
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
    [self.mycollectionView reloadData];
}

@end
