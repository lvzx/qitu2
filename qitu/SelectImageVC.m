//
//  SelectImageVC.m
//  qitu
//
//  Created by 上海企图 on 16/4/25.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "SelectImageVC.h"
#import <Photos/Photos.h>
#import "AssetCell.h"
#import "AssetTableCell.h"
#import "ImagePickerVC.h"

@interface SelectImageVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, PHPhotoLibraryChangeObserver>
{
    UIView *lineView;
}
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UICollectionView *leftCollectView;
@property (strong, nonatomic) UITableView *rightTableView;
@property (nonatomic, strong) NSArray *fetchResults;
@property (nonatomic, strong) NSArray *assetCollections;
@property (nonatomic, strong) NSArray *imgLibArr;//图库
@end

@implementation SelectImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavAndView];
    [self setupPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavAndView {
    [self setNavBackBarSelector:@selector(navBack)];
    
    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 4, 150, 40)];
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 75, 40)];
    [btnLeft setTitle:@"图库" forState:UIControlStateNormal];
    btnLeft.tag = 20;
    [btnLeft addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [navTitleView addSubview:btnLeft];
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(75, 0, 75, 40)];
    [btnRight setTitle:@"手机照片" forState:UIControlStateNormal];
    [btnRight setTitleColor:RGBCOLOR(73, 193, 179) forState:UIControlStateNormal];
    btnRight.tag = 21;
    [btnRight addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [navTitleView addSubview:btnRight];
    lineView = [[UIView alloc] initWithFrame:CGRectMake(75, 37, 75, 3)];
    lineView.backgroundColor = RGBCOLOR(73, 193, 179);
    [navTitleView addSubview:lineView];
    [self.navigationItem setTitleView:navTitleView];

    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:_mainScrollView];
    
    [_mainScrollView addSubview:self.leftCollectView];
    [_mainScrollView addSubview:self.rightTableView];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(kScreenWidth*2, kScreenHeight-64);
    _mainScrollView.contentOffset = CGPointMake(kScreenWidth, 0);
    //取消scrollView默认的内边距64px
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)navBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UICollectionView *)leftCollectView {
    if (_leftCollectView != nil) {
        return _leftCollectView;
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _leftCollectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:flowLayout];
    _leftCollectView.dataSource = self;
    _leftCollectView.delegate = self;
    _leftCollectView.showsHorizontalScrollIndicator = NO;
    _leftCollectView.backgroundColor = RGBCOLOR(57, 57, 57);
    [_leftCollectView registerClass:[AssetCell class] forCellWithReuseIdentifier:@"AssetCell"];
    return _leftCollectView;
}
- (UITableView *)rightTableView {
    if (_rightTableView != nil) {
        return _rightTableView;
    }
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _rightTableView.rowHeight = 80.0;
    _rightTableView.estimatedRowHeight = 80.0;
    UINib *nib = [UINib nibWithNibName:@"AssetTableCell" bundle:nil];
    [_rightTableView registerNib:nib forCellReuseIdentifier:@"AssetTableCell"];
    return _rightTableView;
}
-(void)setupPhotos {
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
    self.fetchResults = @[smartAlbums, userAlbums];
    
    [self updateAssetCollections];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    
}
#pragma mark - Fetching Asset Collections

- (void)updateAssetCollections
{
    // Filter albums
    NSArray *assetCollectionSubtypes = @[
                                         @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                         @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                         @(PHAssetCollectionSubtypeSmartAlbumSelfPortraits),
                                         @(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                         @(PHAssetCollectionSubtypeSmartAlbumScreenshots),
                                         ];
    NSMutableDictionary *smartAlbums = [NSMutableDictionary dictionaryWithCapacity:assetCollectionSubtypes.count];
    NSMutableArray *userAlbums = [NSMutableArray array];
    
    for (PHFetchResult *fetchResult in self.fetchResults) {
        [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
            PHAssetCollectionSubtype subtype = assetCollection.assetCollectionSubtype;
            
            if (subtype == PHAssetCollectionSubtypeAlbumRegular) {
                [userAlbums addObject:assetCollection];
            } else if ([assetCollectionSubtypes containsObject:@(subtype)]) {
                if (!smartAlbums[@(subtype)]) {
                    smartAlbums[@(subtype)] = [NSMutableArray array];
                }
                [smartAlbums[@(subtype)] addObject:assetCollection];
            }
        }];
    }
    
    NSMutableArray *assetCollections = [NSMutableArray array];
    
    // Fetch smart albums
    for (NSNumber *assetCollectionSubtype in assetCollectionSubtypes) {
        NSArray *collections = smartAlbums[assetCollectionSubtype];
        
        if (collections) {
            [assetCollections addObjectsFromArray:collections];
        }
    }
    
    // Fetch user albums
    [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger index, BOOL *stop) {
        [assetCollections addObject:assetCollection];
    }];
    
    self.assetCollections = assetCollections;
    [_rightTableView reloadData];
}
- (UIImage *)placeholderImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *backgroundColor = [UIColor colorWithRed:(239.0 / 255.0) green:(239.0 / 255.0) blue:(244.0 / 255.0) alpha:1.0];
    UIColor *iconColor = [UIColor colorWithRed:(179.0 / 255.0) green:(179.0 / 255.0) blue:(182.0 / 255.0) alpha:1.0];
    
    // Background
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // Icon (back)
    CGRect backIconRect = CGRectMake(size.width * (16.0 / 68.0),
                                     size.height * (20.0 / 68.0),
                                     size.width * (32.0 / 68.0),
                                     size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, backIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(backIconRect, 1.0, 1.0));
    
    // Icon (front)
    CGRect frontIconRect = CGRectMake(size.width * (20.0 / 68.0),
                                      size.height * (24.0 / 68.0),
                                      size.width * (32.0 / 68.0),
                                      size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, -1.0, -1.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, frontIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, 1.0, 1.0));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Action
- (void)touchUpInside:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 20:
        {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect tempRect = lineView.frame;
                tempRect.origin.x = 0;
                lineView.frame = tempRect;
            }];
        }
            break;
        case 21:
        {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect tempRect = lineView.frame;
                tempRect.origin.x = 75;
                lineView.frame = tempRect;
            }];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetTableCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"AssetTableCell"];
    cell.tag = indexPath.row;
    
    // Thumbnail
    PHAssetCollection *assetCollection = self.assetCollections[indexPath.row];
    cell.assetCollection = assetCollection;
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ImagePickerVC *nextVC = [[ImagePickerVC alloc] init];
    nextVC.assets = self.assetCollections[indexPath.row];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgLibArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AssetCell *cell = (AssetCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AssetCell" forIndexPath:indexPath];
    return cell;
}
- (void)dealloc
{
    // Deregister observer
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

@end
