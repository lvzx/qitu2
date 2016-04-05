//
//  SelectBgColor.m
//  qitu
//
//  Created by 上海企图 on 16/4/1.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "SelectBgColor.h"
#import "ColorRect.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

#define SELECTBG_HEIGHT 105
#define COLORBTN_WIDTH 35
#define COLORBTN_HEIGHT 65

@interface SelectBgColor()<UIScrollViewDelegate>
{
    CGFloat offset;
}
@property (nonatomic, strong) UIView *selRenderView;
@property (nonatomic, strong) UIScrollView *bgScrollView;
@property (strong, nonatomic) NSArray *colors;
@end

@implementation SelectBgColor
- (instancetype)initWithColors:(NSArray *)colors {
    self.colors = colors;
    CGRect rect = CGRectMake(0, 0, kScreenWidth, SELECTBG_HEIGHT);
    if (self = [self initWithFrame:rect]) {
        self.backgroundColor = RGBCOLOR(22, 22, 22);
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIEdgeInsets padding = UIEdgeInsetsMake(10, 20, 10, 10);
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.font = [UIFont systemFontOfSize:15.0];
        titleLbl.text = @"透明度";
        [self addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(padding.top);
            make.left.mas_equalTo(padding.left);
        }];
        
        _slider = [[UISlider alloc] init];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        _slider.maximumTrackTintColor = [UIColor whiteColor];
        _slider.minimumValue = 0.1;
        _slider.maximumValue = 1.0;
        [_slider setValue:0.6 animated:YES];
        [_slider setThumbImage:[UIImage imageNamed:@"maka_oval"] forState:UIControlStateNormal];
        [self addSubview:_slider];
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLbl.mas_trailing).with.offset(padding.left);
            make.top.mas_equalTo(padding.top);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-120, 20));
        }];
        
        self.bgScrollView = [[UIScrollView alloc] init];
        self.bgScrollView.showsHorizontalScrollIndicator = NO;
        self.bgScrollView.delegate = self;
        [self setup:self.bgScrollView];
        [self addSubview:self.bgScrollView];
        [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(40);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth, COLORBTN_HEIGHT));
            make.left.equalTo(self.mas_left);
        }];
    }
    return self;
}

- (void)setColorIdx:(NSInteger)colorIdx {
    _colorIdx = colorIdx;
    CGRect temp = _selRenderView.frame;
    temp.origin.x = colorIdx*COLORBTN_WIDTH;
    _selRenderView.frame = temp;
}

- (void)setup:(UIScrollView *)scroView {
    CGFloat contentWidth = COLORBTN_WIDTH*[_colors count];
    CGSize contentSize = CGSizeMake(contentWidth, COLORBTN_HEIGHT);
    scroView.contentSize = contentSize;
    for (NSInteger i = 0; i < [_colors count]; i++) {
        CGRect colorRect = CGRectMake(COLORBTN_WIDTH*i, 0, COLORBTN_WIDTH, COLORBTN_HEIGHT);
        ColorRect *colorBg = [[ColorRect alloc] initWithFrame:colorRect];
        NSString *hexStr = _colors[i];
        colorBg.color = [UIColor colorWithHexString:hexStr];
        [scroView addSubview:colorBg];
    }
    UITapGestureRecognizer *tapGestureRecognizer;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    CGRect renderRect = CGRectMake(_colorIdx*COLORBTN_WIDTH, COLORBTN_HEIGHT-15, COLORBTN_WIDTH, 15);
    self.selRenderView = [[UIView alloc] initWithFrame:renderRect];
    _selRenderView.backgroundColor = RGBCOLOR(22, 22, 22);
    [scroView addSubview:_selRenderView];
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.numberOfTouches <= 0) {
            return;
        }
        CGPoint tapPoint = [sender locationOfTouch:0 inView:self];
        [self update:tapPoint];
    }
}
- (void)update:(CGPoint)tapPoint {
    if (!CGRectContainsPoint((CGRect) {.origin = CGPointZero, .size = self.frame.size}, tapPoint)) {
        return;
    }
    NSLog(@"###%f", tapPoint.x);
    NSInteger colorIndex = floorf((offset+tapPoint.x)/COLORBTN_WIDTH);
    CGRect temp = _selRenderView.frame;
    temp.origin.x = colorIndex*COLORBTN_WIDTH;
    _selRenderView.frame = temp;
    
    self.colorIdx = colorIndex;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectBgColor:)]) {
        [_delegate didSelectBgColor:colorIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    offset = scrollView.contentOffset.x;
    NSLog(@"***%f", offset);
}

@end
