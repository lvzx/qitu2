//
//  DiyTemplateCell.h
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyAPageItem.h"

#import "DiyShowDelgate.h"
#define DIY_CELL_TAG 88
#define DIYCELL_TOPPADDING 30
#define DIYCELL_LEADPADDING 45
#define DIYCELL_PADDING 12
#define DIYCELL_BOTTOMPADDING 60

//@protocol DiyShowDelgate <NSObject>
//- (void)showImgBottomView;
//- (void)showTextBottomView;
//@end

@interface DiyTemplateCell : UIView
@property (nonatomic, strong) DiyAPageItem *aPageItem;
@property (nonatomic, strong) UILabel *numLbl;
@property (nonatomic, strong) UIView *contentView;         // The contentView - default is nil
@property (strong, nonatomic) id<DiyShowDelgate> myDelegate;
//- (void)initCellWithData:(DiyAPageItem *)pageData;
@end
