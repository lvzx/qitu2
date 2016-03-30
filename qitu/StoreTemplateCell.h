//
//  StoreTemplateCell.h
//  qitu
//
//  Created by 上海企图 on 16/3/29.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreTemplateItem.h"

@interface StoreTemplateCell : UICollectionViewCell
@property (nonatomic ,strong) UIImageView *imgView;
@property (nonatomic ,strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *saleNumLbl;

- (void)initCellWithData:(StoreTemplateItem *)item;
@end
