//
//  DiyTemplateScrV.m
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTemplateScrV.h"
#import "DiyTemplateCell.h"

@interface DiyTemplateScrV ()
{
    CGFloat cellW;
    CGFloat cellH;
}
@property (nonatomic, strong) NSMutableArray *pageViewMArr;
@end

@implementation DiyTemplateScrV
- (instancetype)initWithFrame:(CGRect)frame withData:(NSMutableArray *)dataItems {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.pageViewMArr = [NSMutableArray arrayWithCapacity:dataItems.count];
        self.pageMArr = dataItems;
    
        self.backgroundColor = RGBCOLOR(57, 57, 57);
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        //创建底部滑动视图
        [self _initViews];
    }
    return self;
}

- (void)_initViews
{
    cellW = kScreenWidth-90*kScreenWidth/320.0;
    cellH = cellW*36/23.0;
    NSUInteger imgcount = self.pageMArr.count;
    for (NSUInteger i = 0; i < imgcount; i++) {
        DiyAPageItem *OnePageItem = _pageMArr[i];
        CGRect cellRect = CGRectMake(DIYCELL_PADDING+(cellW+DIYCELL_PADDING)*i, DIYCELL_TOPPADDING, cellW, cellH);
        DiyTemplateCell *diyTemplateCell = [[DiyTemplateCell alloc] initWithFrame:cellRect];
        diyTemplateCell.tag = DIY_CELL_TAG + i;
        [diyTemplateCell initCellWithData:OnePageItem];
        [self addSubview:diyTemplateCell];
    }
    self.contentSize = CGSizeMake(DIYCELL_PADDING+(cellW+DIYCELL_PADDING)*imgcount, self.frame.size.height);
}

@end
