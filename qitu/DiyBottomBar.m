//
//  DiyBottomBar.m
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyBottomBar.h"
#import "Masonry.h"

@implementation DiyBottomBar
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    UIEdgeInsets padding = UIEdgeInsetsMake(3, 0, 0, 1);
    CGFloat btnWidth = (kScreenWidth-2)/3.0;
    self.backgroundColor = [UIColor blackColor];
    UIButton *firstBtn = [[UIButton alloc] init];
    firstBtn.backgroundColor = RGBCOLOR(44, 98, 90);
    [firstBtn setImage:[UIImage imageNamed:@"maka_edit7_deletebg_white"] forState:UIControlStateNormal];
    [firstBtn setImage:[UIImage imageNamed:@"maka_edit7_deletebg_white"] forState:UIControlStateSelected];
    [self addSubview:firstBtn];
    
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding.top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(btnWidth);
    }];
    
    UIButton *secondBtn = [[UIButton alloc] init];
    secondBtn.backgroundColor = RGBCOLOR(44, 98, 90);
    [secondBtn setImage:[UIImage imageNamed:@"maka_edit1_background2"] forState:UIControlStateNormal];
    [secondBtn setImage:[UIImage imageNamed:@"maka_edit1_background2"] forState:UIControlStateSelected];
    [self addSubview:secondBtn];
    
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding.top);
        make.left.equalTo(firstBtn.mas_trailing).with.offset(padding.right);
        make.bottom.width.equalTo(firstBtn);
//        make.bottom.equalTo(self.mas_bottom);
//        make.width.mas_equalTo(btnWidth);
    }];

    UIButton *thirdBtn = [[UIButton alloc] init];
    thirdBtn.backgroundColor = RGBCOLOR(44, 98, 90);
    [thirdBtn setImage:[UIImage imageNamed:@"maka_edit2_cut2"] forState:UIControlStateNormal];
    [thirdBtn setImage:[UIImage imageNamed:@"maka_edit2_cut2"] forState:UIControlStateSelected];
    [self addSubview:thirdBtn];
    
    [thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding.top);
        make.left.equalTo(secondBtn.mas_trailing).with.offset(padding.right);
        make.bottom.width.equalTo(firstBtn);
        //        make.bottom.equalTo(self.mas_bottom);
        //        make.width.mas_equalTo(btnWidth);
    }];
}
@end
