//
//  DiyTemplateScrV.m
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTemplateScrV.h"

@interface DiyTemplateScrV ()
{
    CGFloat cellW;
    CGFloat cellH;
}
@end

@implementation DiyTemplateScrV
//- (instancetype)initWithVC:(id)vc withData:(NSMutableArray *)dataItems {
//    self = [super init];
//    if (self) {
//        self.pageViewMArr = [NSMutableArray arrayWithCapacity:dataItems.count];
//        self.pageMArr = dataItems;
//        self.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-50);
//        self.backgroundColor = RGBCOLOR(57, 57, 57);
//        self.showsHorizontalScrollIndicator = NO;
//        self.pagingEnabled = YES;
//        //创建模版视图
//        [self _initViewsWithDel:(id<DiyShowDelgate>)vc];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(57, 57, 57);
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        cellW = kScreenWidth-90*kScreenWidth/320.0;
        cellH = cellW*36/23.0;
        _pageViewMArr = [NSMutableArray array];
    }
    return self;
}
- (void)reloadView {
    NSUInteger imgcount = self.pageMArr.count;
    for (NSUInteger i = 0; i < imgcount; i++) {
        DiyAPageItem *OnePageItem = _pageMArr[i];
        CGRect cellRect = CGRectMake(DIYCELL_LEADPADDING+(cellW+DIYCELL_PADDING)*i, DIYCELL_TOPPADDING, cellW, cellH);
        DiyTemplateCell *diyTemplateCell = [[DiyTemplateCell alloc] initWithFrame:cellRect];
        diyTemplateCell.myDelegate = self.myDelegate;
        diyTemplateCell.tag = DIY_CELL_TAG + i;
        diyTemplateCell.aPageItem = OnePageItem;
        [self addSubview:diyTemplateCell];
    }
    self.contentSize = CGSizeMake(DIYCELL_LEADPADDING*2+(cellW+DIYCELL_PADDING)*imgcount-DIYCELL_PADDING, self.frame.size.height);
}
- (void)addAPageWithItem:(DiyAPageItem *)aPageItem {

}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
@end
