//
//  DiyAddPageView.m
//  qitu
//
//  Created by 上海企图 on 16/4/25.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyAddPageView.h"
#import "Masonry.h"

@implementation DiyAddPageView
- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
    
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(38, 38, 38);
        UIImageView *bgImgV = [[UIImageView alloc] init];
        [bgImgV setImage:[UIImage imageNamed:@"maka_edit_addnew"]];
        [self addSubview:bgImgV];
        [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        CGFloat cellW = kScreenWidth-90*kScreenWidth/320.0;
        CGFloat cellH = cellW*36/23.0;
        CGFloat offsetY = cellH/4;
        _addPageBtn = [[UIButton alloc] init];
        [_addPageBtn setBackgroundImage:[UIImage imageNamed:@"maka_edit4_addpage"] forState:UIControlStateNormal];
        [self addSubview:_addPageBtn];
        [_addPageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(65, 80));
            make.center.mas_equalTo(CGPointMake(0, -offsetY));
        }];
        _addFormBtn = [[UIButton alloc] init];
        [_addFormBtn setBackgroundImage:[UIImage imageNamed:@"maka_edit4_addform"] forState:UIControlStateNormal];
        [self addSubview:_addFormBtn];
        [_addFormBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(65, 80));
            make.center.mas_equalTo(CGPointMake(0, offsetY));
        }];
    }
    return self;
}
@end
