//
//  DiyOnePageCell.m
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyOnePageCell.h"

@implementation DiyOnePageCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = RGBCOLOR(57, 57, 57);
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = RGBCOLOR(213, 213, 213).CGColor;
//        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-55)];
//        [self addSubview:self.imgView];
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

- (void)initCellWithData:(NSDictionary *)pageData {

}
@end
