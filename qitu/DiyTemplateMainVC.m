//
//  DiyTemplateMainVC.m
//  qitu
//
//  Created by 上海企图 on 16/3/31.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTemplateMainVC.h"
#import "SelectBgColor.h"
#import "DiyBottomBar.h"
#import "DiyMainBottomBar.h"
#import "DiyOnePageCell.h"
#import "Masonry.h"
#import "DiyTemplateScrV.h"

@interface DiyTemplateMainVC ()<SelectBgColorDelegate, UIScrollViewDelegate, DiyMainBottomBar, DiyShowDelgate>
{
    CGFloat cellW;
    CGFloat cellH;
    NSArray *bgColors;
    NSMutableArray *pagesArr;
    DiyTemplateScrV *diyTemplateSrcV;
    DiyBottomBar *diyBottomBar;
    DiyMainBottomBar *diyMainBottomBar;
}
//@property (strong, nonatomic) UICollectionView *myCollectionView;

@end

@implementation DiyTemplateMainVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initNavAndView];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
/*
- (UICollectionView *)myCollectionView {
    if (_myCollectionView != nil) {
        return _myCollectionView;
    }

    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-50) collectionViewLayout:flowLayout];
    _myCollectionView.dataSource = self;
    _myCollectionView.delegate = self;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.backgroundColor = RGBCOLOR(57, 57, 57);
    [_myCollectionView registerClass:[DiyOnePageCell class] forCellWithReuseIdentifier:@"DiyOnePageCell"];
    return _myCollectionView;
}
*/
- (void)initNavAndView {
    [self setNavTitle:_myTitle];
    [self setNavBackBarSelector:@selector(navBack)];
    [self setNavRightBarBtnTitle:@"预览" selector:@selector(navPreview)];
    
//    cellW = kScreenWidth-90*kScreenWidth/320.0;
//    cellH = cellW*36/23.0;
    diyMainBottomBar = [[DiyMainBottomBar alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50) actionHandler:self];
    [self.view addSubview:diyMainBottomBar];
    
    diyTemplateSrcV = [[DiyTemplateScrV alloc] initWithVC:self withData:pagesArr];
    [self.view addSubview:diyTemplateSrcV];
    
    diyBottomBar = [[DiyBottomBar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50)];
    [self.view addSubview:diyBottomBar];
    
//    DiyBottomBar *diyBottomBar = [[DiyBottomBar alloc] initWithFrame:CGRectMake(0, 105, kScreenWidth, 50)];
//    bgColors = @[@"#040404", @"#FFFFFF", @"#25CDCF", @"#167FA3", @"#17AFEE",
//                 @"#59C2F2", @"#3B7FBC", @"#0A4CA9", @"#5248FE", @"#6228F2",
//                 @"#676BFB", @"#7751F1", @"#952CBE", @"#CA32AF", @"#F12084"];
//    SelectBgColor *bgColorView = [[SelectBgColor alloc] initWithColors:bgColors];
//    bgColorView.colorIdx = 1;
//    [bgColorView.slider addTarget:self action:@selector(changeAlphaValue) forControlEvents:UIControlEventValueChanged];
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-155, kScreenWidth, 155)];
//    [bottomView addSubview:bgColorView];
//    [bottomView addSubview:diyBottomBar];
//    [self.view addSubview:bottomView];
//    self.view.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:self.myCollectionView];
}

- (void)navBack {

}
- (void)navPreview {

}
#pragma mark - LoadData
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"model" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSASCIIStringEncoding];
    NSError *error;
    NSDictionary *jsonSerialData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (!jsonSerialData && error) {
        NSLog(@"Error:%@", error);
    }
    
    pagesArr = [NSMutableArray array];
    NSArray *scenesArr = jsonSerialData[@"scene"];
    NSInteger scenesCount = [scenesArr count];
    for (NSInteger i = 0; i < scenesCount; i++) {
        NSDictionary *aPageDic = scenesArr[i];
        NSArray *aPageArr = aPageDic[@"content"];
        DiyAPageItem *apageItem = [[DiyAPageItem alloc] init];
        apageItem.bgColor = aPageDic[@"bgcolor"];
        apageItem.bgImgUrl = aPageDic[@"bgpic"];
        apageItem.bgpicwidth = [aPageDic[@"bgpicwidth"] integerValue];
        apageItem.bgpicheight = [aPageDic[@"bgpicheight"] integerValue];
        NSMutableArray *imgArr = [NSMutableArray array];
        NSMutableArray *textArr = [NSMutableArray array];
        for (NSDictionary *pDic in aPageArr) {
            NSString *type = pDic[@"type"];
            if ([type isEqualToString:@"img"]) {
                APageImgItem *imgItem = [APageImgItem mj_objectWithKeyValues:pDic];
                [imgArr addObject:imgItem];
            }else if ([type isEqualToString:@"text"]){
                APageTextItem *textItem = [APageTextItem mj_objectWithKeyValues:pDic];
                [textArr addObject:textItem];
            }
        }
        apageItem.imgsMArr = imgArr;
        apageItem.textMArr = textArr;
        [pagesArr addObject:apageItem];
    }
    NSLog(@"***pagesArr:%@", pagesArr);
}
#pragma mark - DiyMainBottomAction
- (void)touchUpInsideOnBtn:(UIButton *)btn {
    NSLog(@"***DiyMainBottomAction:%@", @(btn.tag));
}
#pragma mark - Alpha changed
- (void)changeAlphaValue {

}

#pragma mark - SelectBgColorDelegate
- (void)didSelectBgColor:(NSInteger)colorIdx {

}

#pragma mark - DiyShowDelgate
- (void)showImgBottomView {
    NSLog(@"showImgBottom View");
    [diyBottomBar reloadDiyBottom:ENUM_DIYIMAGE];
    [UIView animateWithDuration:0.5 animations:^{
        diyBottomBar.frame = CGRectMake(0, kScreenHeight-50, kScreenWidth, 50);
    }];
}
- (void)showTextBottomView {

}
/*
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [pagesArr count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"DiyOnePageCell";
    DiyOnePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    NSInteger row = indexPath.row;
    DiyAPageItem *OnePageItem = pagesArr[row];
    cell.tag = row;
    [cell initCellWithData:OnePageItem];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellW, cellH);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(-10, 12, 30, 12);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(33, cellH);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(33, cellH);
}
 */
@end
