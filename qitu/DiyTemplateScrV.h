//
//  DiyTemplateScrV.h
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyTemplateCell.h"

@interface DiyTemplateScrV : UIScrollView
@property (strong, nonatomic) NSMutableArray *pageMArr;
@property (nonatomic, strong) NSMutableArray *pageViewMArr;//统计视图个数
@property (nonatomic, strong) id<DiyShowDelgate> myDelegate;//点击图片、文本展示bottomView

- (void)addAPageWithItem:(DiyAPageItem *)aPageItem;
- (void)reloadView;
- (void)reloadAPageWithIndex:(NSInteger)index;
@end
