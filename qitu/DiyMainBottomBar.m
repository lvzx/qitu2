//
//  DiyMainBottomBar.m
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyMainBottomBar.h"
#import "Masonry.h"

@implementation DiyMainBottomBar
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _init];
    }
    return self;
}

- (void)_init {
    CGFloat btnWidth = (kScreenWidth)/4.0;
    self.backgroundColor = [UIColor blackColor];
    UIButton *firstBtn = [[UIButton alloc] init];
    firstBtn.tag = ENUM_DIYMAINBOTTOM_FIRST;
    [firstBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [firstBtn setTitle:@"页面" forState:UIControlStateNormal];
    [firstBtn setImage:[UIImage imageNamed:@"maka_edit7_deletebg_white"] forState:UIControlStateNormal];
    [firstBtn addTarget:self action:@selector(touchUpInsideOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:firstBtn];
    
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.mas_equalTo(btnWidth);
    }];
    
    UIButton *secondBtn = [[UIButton alloc] init];
    secondBtn.tag = ENUM_DIYMAINBOTTOM_SECOND;
    [secondBtn setImage:[UIImage imageNamed:@"maka_edit1_background2"] forState:UIControlStateNormal];
    [secondBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [secondBtn setTitle:@"背景" forState:UIControlStateNormal];
    [secondBtn addTarget:self action:@selector(touchUpInsideOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:secondBtn];
    
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBtn);
        make.left.equalTo(firstBtn.mas_right);
        make.size.equalTo(firstBtn);
    }];
    
    UIButton *thirdBtn = [[UIButton alloc] init];
    thirdBtn.tag = ENUM_DIYMAINBOTTOM_THIRD;
    [thirdBtn setImage:[UIImage imageNamed:@"maka_edit2_cut2"] forState:UIControlStateNormal];
    [thirdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [thirdBtn setTitle:@"添加" forState:UIControlStateNormal];
    [thirdBtn addTarget:self action:@selector(touchUpInsideOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:thirdBtn];
    
    [thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBtn);
        make.left.equalTo(secondBtn.mas_right);
        make.size.equalTo(firstBtn);
    }];
    
    UIButton *fourthBtn = [[UIButton alloc] init];
    fourthBtn.tag = ENUM_DIYMAINBOTTOM_FOURTH;
    [fourthBtn setImage:[UIImage imageNamed:@"maka_edit2_cut2"] forState:UIControlStateNormal];
    [fourthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fourthBtn setTitle:@"音乐" forState:UIControlStateNormal];
    [fourthBtn addTarget:self action:@selector(touchUpInsideOnBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:thirdBtn];
    
    [fourthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBtn);
        make.left.equalTo(thirdBtn.mas_right);
        make.size.equalTo(firstBtn);
    }];

}

@end
