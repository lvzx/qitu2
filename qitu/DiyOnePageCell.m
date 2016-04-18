//
//  DiyOnePageCell.m
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyOnePageCell.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "APageImgScrV.h"
#import "APageImgView.h"
#import "APageTextLabel.h"

@interface DiyOnePageCell ()
@property (strong, nonatomic) UIImageView *backgroundImg;

@end

@implementation DiyOnePageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        self.layer.borderWidth = 0.8;
        self.layer.borderColor = RGBCOLOR(213, 213, 213).CGColor;
        self.backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        [self addSubview:self.backgroundImg];
        
        UIView *pageNumV = [[UIView alloc] initWithFrame:CGRectMake(width-35, height-35, 35, 35)];
        pageNumV.backgroundColor = [UIColor blackColor];
        pageNumV.alpha = 0.5;
        UILabel *numLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 35, 28)];
        numLbl.textColor = [UIColor whiteColor];
        numLbl.textAlignment = NSTextAlignmentCenter;
        numLbl.text = [NSString stringWithFormat:@"%@", @(self.tag+1)];
        [pageNumV addSubview:numLbl];
        [self addSubview:pageNumV];
//
//        self.titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame), 20)];
//        self.titleLbl.font = [UIFont systemFontOfSize:15.0];
//        self.titleLbl.textColor = RGBCOLOR(156, 156, 156);
//        [self addSubview:self.titleLbl];
//        
//        self.priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLbl.frame), CGRectGetWidth(self.frame), 18)];
//        self.priceLbl.font = [UIFont systemFontOfSize:14.0];
//        self.priceLbl.textColor = RGBCOLOR(31, 182, 162);
//        [self addSubview:self.priceLbl];
//        
//        self.saleNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLbl.frame), CGRectGetWidth(self.frame), 17)];
//        self.saleNumLbl.font = [UIFont systemFontOfSize:12.0];
//        self.saleNumLbl.textColor = RGBCOLOR(184, 184, 184);
//        [self addSubview:self.saleNumLbl];
    }
    return self;
}

- (void)initCellWithData:(DiyAPageItem *)pageData {
    self.contentView.backgroundColor = [UIColor colorWithHexString:pageData.bgColor];
    [self.backgroundImg sd_setImageWithURL:[NSURL URLWithString:pageData.bgImgUrl]];
    
    CGFloat bili = kScreenWidth/(pageData.bgpicwidth/2);
    NSLog(@"&&&%ld, %f, %f",pageData.bgpicwidth, kScreenWidth, bili);
    for (APageImgItem *imgItem in pageData.imgsMArr) {
//        APageImgView *imgV = [[APageImgView alloc] initWithFrame:CGRectMake(imgItem.img_x*bili, imgItem.img_y*bili, imgItem.imgWidth*bili, 200*bili)];
        APageImgScrV *imgV = [[APageImgScrV alloc] initWithFrame:CGRectMake(imgItem.img_x*bili+CREATOR_IMG_PADDING, imgItem.img_y*bili+CREATOR_IMG_PADDING, imgItem.imgWidth*bili+2*CREATOR_IMG_PADDING, 200*bili+2*CREATOR_IMG_PADDING)];
        [imgV initImgViewWith:imgItem];
        [self addSubview:imgV];
    }
    
    for (APageTextItem *txtItem in pageData.textMArr) {
        APageTextLabel *textLbl = [[APageTextLabel alloc] initWithFrame:CGRectMake(txtItem.txt_x*bili, txtItem.txt_y*bili, txtItem.tx_width*bili, 100*bili)];
        TextItem *textItem = txtItem.textItem;
        textLbl.textColor = [UIColor colorWithHexString:textItem.txtColorHexStr];
        textLbl.text = textItem.text;
        textLbl.font = [UIFont systemFontOfSize:textItem.fontSize*bili];
        [self addSubview:textLbl];
    }
}
@end
