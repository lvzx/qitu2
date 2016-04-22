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
@property (nonatomic, strong) NSMutableArray *pageViewMArr;
@end

@implementation DiyTemplateScrV
- (instancetype)initWithVC:(id)vc withData:(NSMutableArray *)dataItems {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.pageViewMArr = [NSMutableArray arrayWithCapacity:dataItems.count];
        self.pageMArr = dataItems;
        self.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-50);
        self.backgroundColor = RGBCOLOR(57, 57, 57);
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        //创建底部滑动视图
        [self _initViewsWithDel:(id<DiyShowDelgate>)vc];
    }
    return self;
}

- (void)_initViewsWithDel:(id<DiyShowDelgate>)vc
{
    cellW = kScreenWidth-90*kScreenWidth/320.0;
    cellH = cellW*36/23.0;
    NSUInteger imgcount = self.pageMArr.count;
    for (NSUInteger i = 0; i < imgcount; i++) {
        DiyAPageItem *OnePageItem = _pageMArr[i];
        CGRect cellRect = CGRectMake(DIYCELL_LEADPADDING+(cellW+DIYCELL_PADDING)*i, DIYCELL_TOPPADDING, cellW, cellH);
        DiyTemplateCell *diyTemplateCell = [[DiyTemplateCell alloc] initWithFrame:cellRect];
        diyTemplateCell.myDelegate = vc;
        diyTemplateCell.tag = DIY_CELL_TAG + i;
        diyTemplateCell.aPageItem = OnePageItem;
        [self addSubview:diyTemplateCell];
    }
    self.contentSize = CGSizeMake(DIYCELL_LEADPADDING*2+(cellW+DIYCELL_PADDING)*imgcount-DIYCELL_PADDING, self.frame.size.height);
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
@end
