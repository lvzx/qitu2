//
//  DiyBottomBar.m
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyBottomBar.h"
#import "Masonry.h"
@interface DiyBottomBar ()
@property (strong, nonatomic) UIButton *firstBtn;
@property (strong, nonatomic) UIButton *secondBtn;
@property (strong, nonatomic) UIButton *thirdBtn;
@end

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
    self.firstBtn = [[UIButton alloc] init];
    _firstBtn.tag = 40;
    _firstBtn.backgroundColor = RGBCOLOR(44, 98, 90);
    [_firstBtn setImage:[UIImage imageNamed:@"maka_edit7_deletebg_white"] forState:UIControlStateNormal];
    [self addSubview:_firstBtn];
    
    [_firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding.top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(btnWidth);
    }];
    
    self.secondBtn = [[UIButton alloc] init];
    _secondBtn.tag = 41;
    _secondBtn.backgroundColor = RGBCOLOR(44, 98, 90);
    [_secondBtn setImage:[UIImage imageNamed:@"maka_edit1_background2"] forState:UIControlStateNormal];
    [self addSubview:_secondBtn];
    
    [_secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding.top);
        make.left.equalTo(_firstBtn.mas_trailing).with.offset(padding.right);
        make.bottom.width.equalTo(_firstBtn);
    }];

    self.thirdBtn = [[UIButton alloc] init];
    _thirdBtn.tag = 42;
    _thirdBtn.backgroundColor = RGBCOLOR(44, 98, 90);
    [_thirdBtn setImage:[UIImage imageNamed:@"maka_edit2_cut2"] forState:UIControlStateNormal];
    [self addSubview:_thirdBtn];
    
    [_thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(padding.top);
        make.left.equalTo(_secondBtn.mas_trailing).with.offset(padding.right);
        make.bottom.width.equalTo(_firstBtn);
    }];
}
- (void)setActionHandler:(id)target {
    [_firstBtn addTarget:target action:@selector(didSelectDiyBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_secondBtn addTarget:target action:@selector(didSelectDiyBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_thirdBtn addTarget:target action:@selector(didSelectDiyBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)reloadDiyBottom:(ENUM_DIYBOTTOMTYPE)style {
    switch (style) {
        case ENUM_DIYBACKGROUND:
        {
            [_firstBtn setImage:[UIImage imageNamed:@"maka_edit7_deletebg_white"] forState:UIControlStateNormal];
            [_secondBtn setImage:[UIImage imageNamed:@"maka_edit1_background2"] forState:UIControlStateNormal];
            [_thirdBtn setImage:[UIImage imageNamed:@"maka_edit2_cut2"] forState:UIControlStateNormal];
        }
            break;
        case ENUM_DIYIMAGE:
        {
        
        }
            break;
        case ENUM_DIYTEXT:
        {
        
        }
            break;
        default:
            break;
    }
}
@end
