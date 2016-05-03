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
#import "DiyAddPageView.h"
#import "DiyCollectionView.h"
#import "SelectImageVC.h"

@interface DiyTemplateMainVC ()<SelectBgColorDelegate, DiyMainBottomBar, DiyBottomBarDelegate, DiyShowDelgate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate, UIActionSheetDelegate>
{
    CGFloat cellW;
    CGFloat cellH;
    CGFloat cellPadding;
    NSArray *bgColors;
    NSMutableArray *pagesArr;
    NSInteger _curPageIndex;

    DiyBottomBar *diyBottomBar;
    DiyMainBottomBar *diyMainBottomBar;
    ENUM_DIY_TYPE bottomStyle;
    
    UIView *_preSelectedElement;//上一次选中的图、文
    UIView *_selectedElement;//当前选中的图、文
}
@property (strong, nonatomic) DiyCollectionView *myCollectionView;
@end

@implementation DiyTemplateMainVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self initNavAndView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:@"CropOK" object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (DiyCollectionView *)myCollectionView {
    if (_myCollectionView != nil) {
        return _myCollectionView;
    }

    cellPadding = 45*kScreenWidth/320.0;
    cellW = kScreenWidth-2*cellPadding;
    cellH = cellW*36/23.0;
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _myCollectionView = [[DiyCollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-50) collectionViewLayout:flowLayout];
    _myCollectionView.dataSource = self;
    _myCollectionView.delegate = self;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    _myCollectionView.backgroundColor = RGBCOLOR(57, 57, 57);
    [_myCollectionView registerClass:[DiyOnePageCell class] forCellWithReuseIdentifier:@"DiyOnePageCell"];
    return _myCollectionView;
}

- (void)initNavAndView {
    [self setNavTitle:_myTitle];
    [self setNavBackBarSelector:@selector(navBack)];
    [self setNavRightBarBtnTitle:@"预览" selector:@selector(navPreview)];
    
    diyMainBottomBar = [[DiyMainBottomBar alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50) actionHandler:self];
    [self.view addSubview:diyMainBottomBar];
   
    diyBottomBar = [[DiyBottomBar alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 50)];
    [diyBottomBar setActionHandler:self];
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
    [self.view addSubview:self.myCollectionView];
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
- (void)notificationHandler: (NSNotification *)notification {
    
    NSDictionary *info = notification.object;
    UIImage *image = info[@"image"];
    NSString *destImgPath = info[@"imgPath"];
    NSLog(@"&&&%@, destImgPath:%@", notification.object, destImgPath);
    if ([_selectedElement isKindOfClass:[APageImgView class]]) {
        APageImgView *imgView = (APageImgView *)_selectedElement;
        [imgView updateImage:image withSize:image.size];
    }
}

#pragma mark - DiyMainBottomAction
- (void)touchUpInsideOnBtn:(UIButton *)btn {
    NSLog(@"***DiyMainBottomAction:%@", @(btn.tag));
}
#pragma mark - DiyBottomBarDelegate
- (void)didSelectDiyBottomBtn:(UIButton *)btn {
    switch (btn.tag) {
        case 40:
        {
            if (bottomStyle == ENUM_DIYIMAGE) {
                //删除
                UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定删除图片？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil];
                actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
                [actionSheet showInView:self.view];
                
            }else if (bottomStyle == ENUM_DIYTEXT) {
            
            }
        }
            break;
        case 41:
        {
            if (bottomStyle == ENUM_DIYIMAGE) {
                //更换图片
                SelectImageVC *nextView = [[SelectImageVC alloc] init];
                nextView.imgSize = _selectedElement.frame.size;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nextView];
                [self presentViewController:nav animated:YES completion:nil];
                
            }else if (bottomStyle == ENUM_DIYTEXT) {
                
            }

        }
            break;
        case 42:
        {
            if (bottomStyle == ENUM_DIYIMAGE) {
                
            }else if (bottomStyle == ENUM_DIYTEXT) {
                
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - Alpha changed
- (void)changeAlphaValue {

}

#pragma mark - SelectBgColorDelegate
- (void)didSelectBgColor:(NSInteger)colorIdx {

}

#pragma mark - DiyShowDelgate
- (void)showImgBottomView:(UIView *)element {
    NSLog(@"showImgBottom View");
    
    if (_selectedElement != nil) {
        _preSelectedElement = _selectedElement;
        _selectedElement = nil;
    }
    
    _selectedElement = element;
    
    if (_preSelectedElement && _preSelectedElement == _selectedElement) {
        return;
    }
    
    [self clearOverBorders];
    
    bottomStyle = ENUM_DIYIMAGE;
    [diyBottomBar reloadDiyBottom:bottomStyle];
    [UIView animateWithDuration:0.5 animations:^{
        diyBottomBar.frame = CGRectMake(0, kScreenHeight-50, kScreenWidth, 50);
    }];
}
- (void)showTextBottomView:(UIView *)element {
    bottomStyle = ENUM_DIYTEXT;
    [diyBottomBar reloadDiyBottom:bottomStyle];
    [UIView animateWithDuration:0.5 animations:^{
        diyBottomBar.frame = CGRectMake(0, kScreenHeight-50, kScreenWidth, 50);
    }];
}

- (void)clearOverBorders {
    if (_preSelectedElement != nil) {
        
        if ([_preSelectedElement isKindOfClass:[APageImgView class]]) {
            APageImgView *imgView = (APageImgView *)_preSelectedElement;
            imgView.hasBorder = NO;
        }//else if (_preSelectedElement isKindOfClass:[])
        else {
           
        }
    }else {
       
    }
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [pagesArr count]+1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    static NSString *identify = @"DiyOnePageCell";
    DiyOnePageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (row < [pagesArr count]) {
        DiyAPageItem *OnePageItem = pagesArr[row];
        cell.myDelegate = self;
        cell.tag = DIY_CELL_TAG+row;
        cell.aPageItem = OnePageItem;
    }else {
        DiyAddPageView *addView = [[DiyAddPageView alloc] initWithFrame:cell.contentView.frame];
        [cell addSubview:addView];
    }
    
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

#pragma mark - UIScrollViewDelegate
- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = cellW+12;
    _curPageIndex = round(offset.x/pageSize);
    CGFloat targetX = offset.x;
    if (targetX > _curPageIndex*pageSize+20) {
        if (_curPageIndex<[pagesArr count]) {
            _curPageIndex++;
        }
        targetX = _curPageIndex*pageSize;
       
    }else if (targetX < _curPageIndex*pageSize-20){
        if (_curPageIndex > 0) {
            _curPageIndex--;
        }
        targetX = _curPageIndex*pageSize;
    }
    return CGPointMake(targetX, offset.y);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    NSLog(@"targetOffset:%@", NSStringFromCGPoint(targetOffset));
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"**%@", @(buttonIndex));
    if (buttonIndex == 0) {
       //执行删除操作
    }
}
@end
