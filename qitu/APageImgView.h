//
//  APageImgView.h
//  qitu
//
//  Created by 上海企图 on 16/4/21.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APageImgItem.h"
#import "DiyShowDelgate.h"
@class DiyAPageItem;

@interface APageImgView : UIView

@property (nonatomic, strong) DiyAPageItem *pageItem;
@property (assign, nonatomic) NSInteger imgIdx;//此图在imgsMArr中的索引

@property (nonatomic, strong) APageImgItem* imgItem;

@property (nonatomic, assign) BOOL hasBorder;
@property (nonatomic, strong) UIImage *image;
@property (assign, nonatomic) id<DiyShowDelgate> myDelegate;

- (void)updateImage:(UIImage *)image withSize:(CGSize)size;
@end
