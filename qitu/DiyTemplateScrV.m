//
//  DiyTemplateScrV.m
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTemplateScrV.h"
#import "DiyAddPageView.h"

@interface DiyTemplateScrV ()
{
    CGFloat cellW;
    CGFloat cellH;
    DiyAddPageView *addPageV;
}
@end

@implementation DiyTemplateScrV

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(57, 57, 57);
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        cellW = kScreenWidth-90*kScreenWidth/320.0;
        cellH = cellW*36/23.0;
        _pageViewMArr = [NSMutableArray array];
        
        addPageV = [[DiyAddPageView alloc] init];
        [self addSubview:addPageV];
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
    [self updateOverView:imgcount];
    self.contentSize = CGSizeMake(DIYCELL_LEADPADDING*2+(cellW+DIYCELL_PADDING)*(imgcount+1)-DIYCELL_PADDING, self.frame.size.height);
}
- (void)updateOverView:(NSInteger)index {
    CGRect cellRect = CGRectMake(DIYCELL_LEADPADDING+(cellW+DIYCELL_PADDING)*index, DIYCELL_TOPPADDING, cellW, cellH);
    addPageV.frame = cellRect;
    [self layoutIfNeeded];
}
- (void)addAPageWithItem:(DiyAPageItem *)aPageItem {

}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
@end
