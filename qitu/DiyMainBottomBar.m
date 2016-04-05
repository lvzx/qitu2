//
//  DiyMainBottomBar.m
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyMainBottomBar.h"
#import "Masonry.h"
@interface DiyMainBottomBar ()
{
    CGFloat btnWidth;
    CGFloat btnHeight;
}
@end

@implementation DiyMainBottomBar
- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame actionHandler:(id)target{
    if (self = [super initWithFrame:frame]) {
        btnWidth = (kScreenWidth)/4.0;
        btnHeight = CGRectGetHeight(frame);
        [self _initWithHandler:target];
    }
    return self;
}

- (void)_initWithHandler:(id)target {
    
    self.backgroundColor = [UIColor blackColor];
    NSArray *dataArr = @[@{@"image":@"maka_edit1_add", @"text":@"页面"},
                         @{@"image":@"maka_edit1_add", @"text":@"背景"},
                         @{@"image":@"maka_edit1_add", @"text":@"添加"},
                         @{@"image":@"maka_edit1_add", @"text":@"音乐"}
                         ];
    for (NSInteger i = 0; i < 4; i++) {
        CGRect btnRect = CGRectMake(btnWidth*i, 0, btnWidth, btnHeight);
        UIButton *btn = [[UIButton alloc] initWithFrame:btnRect];
        btn.tag = 30+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:dataArr[i][@"text"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:dataArr[i][@"image"]] forState:UIControlStateNormal];
        [btn addTarget:target action:@selector(touchUpInsideOnBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
@end
