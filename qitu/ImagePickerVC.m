//
//  ImagePickerVC.m
//  qitu
//
//  Created by 上海企图 on 16/4/26.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "ImagePickerVC.h"
#import "CropImageViewController.h"

@interface ImageAssetCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) PHAsset *imgAsset;
@property (nonatomic, assign) PHImageRequestID imageRequestID;

@end

@implementation ImageAssetCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageRequestID = PHInvalidImageRequestID;
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.imageView.bounds = self.bounds;
}

- (void)prepareForReuse {
    [self cancelImageRequest];
    self.imageView.image = nil;
}

- (void)cancelImageRequest {
    if (self.imageRequestID != PHInvalidImageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
        self.imageRequestID = PHInvalidImageRequestID;
    }
}

- (void)setImgAsset:(PHAsset *)imgAsset {
    if (_imgAsset != imgAsset) {
        _imgAsset = imgAsset;
        
        [self cancelImageRequest];
        
        if (_imgAsset) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize size = CGSizeMake(self.bounds.size.width * scale, self.bounds.size.height * scale);
            self.imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:_imgAsset
                                                                             targetSize:size
                                                                            contentMode:PHImageContentModeAspectFill
                                                                                options:options
                                                                          resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                              if (_imgAsset == imgAsset) {
                                                                                  self.imageView.image = result;
                                                                              }
                                                                          }];
        }
        
    }
}

//- (void)setSelected:(BOOL)selected {
//    [super setSelected:selected];
//    //self.checkmarkImageView.hidden = !selected;
//    self.imageView.alpha = selected ? 0.7 : 1.0;
//}

@end
 
@interface ImagePickerVC ()
//@property (nonatomic, strong) NSMutableSet *selectedAssets;
@property (nonatomic, strong) NSMutableOrderedSet *assetOrderedSet;
@property (nonatomic, strong) UIImage *selectImage;
@end

@implementation ImagePickerVC

static NSString * const reuseIdentifier = @"ImageAssetCell";
- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat w = ((kScreenWidth-2) / 3);
    layout.itemSize = CGSizeMake(w, w);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
         self.assetOrderedSet = [NSMutableOrderedSet orderedSet];
        [self setUpNav];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[ImageAssetCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNav {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"maka_navbar_return"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"maka_navbar_return"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setAssets:(PHAssetCollection *)assets {
    if (_assets != assets) {
         _assets = assets;
    }
    PHFetchOptions *options = [PHFetchOptions new];
    options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    
    [self.assetOrderedSet removeAllObjects];
    
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:_assets options:options];
    [fetchResult enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.assetOrderedSet addObject:obj];
    }];
    NSLog(@"$$$$%@**%@",_assets, _assetOrderedSet);
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetOrderedSet.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    PHAsset *asset = self.assetOrderedSet[indexPath.item];
    cell.imgAsset = asset;
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = self.assetOrderedSet[indexPath.item];
    
    CGSize itemSize = [(UICollectionViewFlowLayout *)collectionView.collectionViewLayout itemSize];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(itemSize.width*scale, itemSize.height*scale);
    
//    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
//    option.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:targetSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                self.selectImage = result;
                                            }];
    
    CropImageViewController *nextView = [[CropImageViewController alloc] initWithNibName:@"CropImageViewController" bundle:nil];
    nextView.orginalImage = self.selectImage;
    [self.navigationController pushViewController:nextView animated:YES];
    /*
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(imagePickerController:didPickImage:)]) {
        [_myDelegate imagePickerController:self didPickImage:self.selectImage];
    }*/
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
