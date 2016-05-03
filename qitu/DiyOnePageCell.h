//
//  DiyOnePageCell.h
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APageImgView.h"
#import "APageTextLabel.h"
#import "DiyAPageItem.h"
#import "DiyShowDelgate.h"

#define DIY_CELL_TAG 88
#define DIYCELL_TOPPADDING 30
#define DIYCELL_LEADPADDING 45
#define DIYCELL_PADDING 12
#define DIYCELL_BOTTOMPADDING 60


static const NSInteger kCellElementTag = 44;

@interface DiyOnePageCell : UICollectionViewCell

@property (strong, nonatomic) DiyAPageItem *aPageItem;
@property (strong, nonatomic) id<DiyShowDelgate> myDelegate;

@end
