//
//  DiyTextStyleView.m
//  qitu
//
//  Created by 上海企图 on 16/5/6.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTextStyleView.h"
#import "UIColor+Hex.h"
#import "Masonry.h"

@protocol ColorView
@property (strong, nonatomic) UIColor *color;
@end

@interface ColorView : UIView<ColorView>

@end

@implementation ColorView
@synthesize color;

- (void)drawRect:(CGRect)rect {
    CGRect colorRect = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:colorRect];
    [rectanglePath closePath];
    [self.color setFill];
    [rectanglePath fill];
}
@end

static const CGFloat kTextStyleViewH = 160;
static const CGFloat kColorSelectorH = 65;
static const CGFloat kColorSelectorW = 35;

@interface DiyTextStyleView()<UIScrollViewDelegate>
{
    CGFloat offset;
}
@property (nonatomic, strong) UIImageView *textAlignImgV;
@property (nonatomic, strong) UIView *colorSelRenderV;
@property (nonatomic, strong) UIScrollView *colorScrollView;
@property (strong, nonatomic) NSArray *colors;
@end

@implementation DiyTextStyleView

- (instancetype)initWithColors:(NSArray *)colors {
    self.colors = colors;
    CGRect rect = CGRectMake(0, kScreenHeight-kTextStyleViewH, kScreenWidth, kTextStyleViewH);
    if (self = [self initWithFrame:rect]) {
        self.backgroundColor = RGBCOLOR(22, 22, 22);
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTextAlignBtn];
        [self addSelectColorView];
        [self addTextFontSlider];
    }
    return self;
}

- (void)setColorIdx:(NSInteger)colorIdx {
    _colorIdx = colorIdx;
    CGRect temp = _colorSelRenderV.frame;
    temp.origin.x = colorIdx*kColorSelectorW;
    _colorSelRenderV.frame = temp;
}
- (void)setTextAlign:(ENUM_DIY_TEXTALIGN)textAlign {
    _textAlign = textAlign;
    switch (_textAlign) {
        case ENUM_DIY_TEXTLEFT:
            self.textAlignImgV.image = [UIImage imageNamed:@"maka_edit3_left"];
            break;
        case ENUM_DIY_TEXTMIDDLE:
            self.textAlignImgV.image = [UIImage imageNamed:@"maka_edit3_middle"];
            break;
        case ENUM_DIY_TEXTRIGHT:
            self.textAlignImgV.image = [UIImage imageNamed:@"maka_edit3_right"];
            break;
        default:
            break;
    }
}

- (void)addTextAlignBtn {
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 20, 10, 10);
    self.textAlignImgV = [[UIImageView alloc] init];
    _textAlignImgV.userInteractionEnabled = YES;
    [self addSubview:_textAlignImgV];
    [_textAlignImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(padding.top);
        make.left.mas_equalTo(padding.left);
        make.size.mas_equalTo(CGSizeMake(180, 30));
    }];
    [self setupTextAlignImgV];
}

- (void)setupTextAlignImgV {
    UITapGestureRecognizer *tapGestureRecognizer;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTextAlignTap:)];
    [_textAlignImgV addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTextAlignTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (sender.numberOfTouches <= 0) {
            return;
        }
        CGPoint tapPoint = [sender locationOfTouch:0 inView:self];
        
        if (!CGRectContainsPoint((CGRect) {.origin = CGPointZero, .size = self.frame.size}, tapPoint)) {
            return;
        }
        
        NSInteger AlignValue = floorf((offset+tapPoint.x)/60);
        self.textAlign = (ENUM_DIY_TEXTALIGN)AlignValue;
        
        if (_delegate && [_delegate respondsToSelector:@selector(didSelectTextAlign:)]) {
            [_delegate didSelectTextAlign:_textAlign];
        }
    }
}

- (void)addSelectColorView {
    self.colorScrollView = [[UIScrollView alloc] init];
    self.colorScrollView.showsHorizontalScrollIndicator = NO;
    self.colorScrollView.delegate = self;
    [self setupColorScrollView:self.colorScrollView];
    [self addSubview:self.colorScrollView];
    [_colorScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(50);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kColorSelectorH));
        make.left.equalTo(self.mas_left);
    }];
}

- (void)setupColorScrollView:(UIScrollView *)scroView {
    CGFloat contentWidth = kColorSelectorW*[_colors count];
    CGSize contentSize = CGSizeMake(contentWidth, kColorSelectorH);
    scroView.contentSize = contentSize;
    for (NSInteger i = 0; i < [_colors count]; i++) {
        CGRect colorRect = CGRectMake(kColorSelectorW*i, 0, kColorSelectorW, kColorSelectorH);
        ColorView *colorBg = [[ColorView alloc] initWithFrame:colorRect];
        NSString *hexStr = _colors[i];
        colorBg.color = [UIColor colorWithHexString:hexStr];
        [scroView addSubview:colorBg];
    }
    UITapGestureRecognizer *tapGestureRecognizer;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [scroView addGestureRecognizer:tapGestureRecognizer];
    
    CGRect renderRect = CGRectMake(_colorIdx*kColorSelectorW, kColorSelectorH-15, kColorSelectorW, 15);
    self.colorSelRenderV = [[UIView alloc] initWithFrame:renderRect];
    _colorSelRenderV.backgroundColor = RGBCOLOR(22, 22, 22);
    [scroView addSubview:_colorSelRenderV];
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

    NSInteger colorIndex = floorf((offset+tapPoint.x)/kColorSelectorW);
    CGRect temp = _colorSelRenderV.frame;
    temp.origin.x = colorIndex*kColorSelectorW;
    _colorSelRenderV.frame = temp;
    
    self.colorIdx = colorIndex;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectBgColor:)]) {
        [_delegate didSelectBgColor:colorIndex];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    offset = scrollView.contentOffset.x;
}

- (void)addTextFontSlider {
    UIEdgeInsets padding = UIEdgeInsetsMake(12, 10, -12, -10);
    UILabel *leftLbl = [[UILabel alloc] init];
    leftLbl.textColor = [UIColor whiteColor];
    leftLbl.textAlignment = NSTextAlignmentCenter;
    leftLbl.text = @"小";
    leftLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:leftLbl];
    [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding.left);
        make.bottom.mas_equalTo(padding.bottom);
        make.size.mas_equalTo(CGSizeMake(30, 21));
    }];
    UILabel *rightLbl = [[UILabel alloc] init];
    rightLbl.textAlignment = NSTextAlignmentCenter;
    rightLbl.textColor = [UIColor whiteColor];
    rightLbl.text = @"大";
    rightLbl.font = [UIFont systemFontOfSize:15];
    [self addSubview:rightLbl];
    [rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.bottom.mas_equalTo(leftLbl);
        make.right.mas_equalTo(padding.right);
    }];
    
    self.fontSizeSlider = [[UISlider alloc] init];
    _fontSizeSlider.minimumTrackTintColor = [UIColor whiteColor];
    _fontSizeSlider.maximumTrackTintColor = [UIColor whiteColor];
    _fontSizeSlider.minimumValue = 10;
    _fontSizeSlider.maximumValue = 50;

    [_fontSizeSlider setThumbImage:[UIImage imageNamed:@"maka_oval"] forState:UIControlStateNormal];
    [self addSubview:_fontSizeSlider];
    [_fontSizeSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(padding.bottom);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-100, 20));
    }];
}

@end
