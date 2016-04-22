//
//  DiyTemplateCell.m
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTemplateCell.h"
#import "UIColor+Hex.h"
#import "UIImageView+WebCache.h"
#import "APageImageView.h"
#import "BorderView.h"
#import "APageTextLabel.h"
#import "TextBorderView.h"
#import "DiyRelatedEnum.h"
#import "APageImgView.h"

@interface DiyTemplateCell()
{
    NSMutableArray *imgViewMArr;//成员APageImageView对象
    NSMutableArray *textLblMArr;//成员APageTextLabel对象
    ENUM_DIY_TYPE diyContentType;//背景、图片、文本
    CGPoint originalLocation;
    
    APageImgView *selImgView;
    APageTextLabel *selTextLbl;
    
    //UIView *targetView;//touch move指定编辑的view
}
@property (strong, nonatomic) UIImageView *backgroundImg;

@end

@implementation DiyTemplateCell

//////////////////////////////////////////////////////////////
#pragma mark Constructors
//////////////////////////////////////////////////////////////

- (id)init
{
    return self = [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
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
        self.numLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 35, 28)];
        _numLbl.textColor = [UIColor whiteColor];
        _numLbl.textAlignment = NSTextAlignmentCenter;
        [pageNumV addSubview:_numLbl];
        [self addSubview:pageNumV];
    }
    return self;
}
//////////////////////////////////////////////////////////////
#pragma mark Setters / getters
//////////////////////////////////////////////////////////////

- (void)setContentView:(UIView *)contentView
{
    [self.contentView removeFromSuperview];
    if(self.contentView)
    {
        contentView.frame = self.contentView.frame;
    }
    else
    {
        contentView.frame = self.bounds;
    }
    
    _contentView = contentView;
    
    self.contentView.autoresizingMask = UIViewAutoresizingNone;
    [self addSubview:self.contentView];
}

- (void)initCellWithData:(DiyAPageItem *)pageData {
    self.backgroundImg.backgroundColor = [UIColor colorWithHexString:pageData.bgColor];
    [self.backgroundImg sd_setImageWithURL:[NSURL URLWithString:pageData.bgImgUrl]];
    self.numLbl.text = [NSString stringWithFormat:@"%@", @(self.tag-DIY_CELL_TAG+1)];
    CGFloat bili = kScreenWidth/pageData.bgpicwidth;
    
    imgViewMArr = [[NSMutableArray alloc] init];
    textLblMArr = [[NSMutableArray alloc] init];
    for (APageImgItem *imgItem in pageData.imgsMArr) {
        APageImgView *imgV = [[APageImgView alloc] init];
        
        imgV.frame = CGRectMake(imgItem.img_x*bili-CREATOR_IMG_PADDING, imgItem.img_y*bili-CREATOR_IMG_PADDING, imgItem.imgWidth*bili+2*CREATOR_IMG_PADDING, imgItem.imgHeight*bili+2*CREATOR_IMG_PADDING);
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [imgV addGestureRecognizer:panGesture];
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [imgV addGestureRecognizer:pinchGesture];
//                              WithFrame:CGRectMake(imgItem.img_x*bili, imgItem.img_y*bili, imgItem.imgWidth*bili, imgItem.imgHeight*bili)];
        //imgV.borderSize = self.frame.size;
//        imgV.myDelegate = self.myDelegate;
        [imgV setImage:[UIImage imageNamed:imgItem.imgStr]];
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [self addGestureRecognizer:tapGesture];
        [self addSubview:imgV];
        [imgViewMArr addObject:imgV];
    }
    
    for (APageTextItem *txtItem in pageData.textMArr) {
        APageTextLabel *textLbl = [[APageTextLabel alloc] initWithFrame:CGRectMake(txtItem.txt_x*bili-CREATOR_IMG_PADDING, txtItem.txt_y*bili-CREATOR_IMG_PADDING, txtItem.txt_width*bili+2*CREATOR_IMG_PADDING, txtItem.txt_height*bili+2*CREATOR_IMG_PADDING)];
        TextItem *textItem = txtItem.textItem;
        textLbl.textColor = [UIColor colorWithHexString:textItem.txtColorHexStr];
        NSString *txtStr = [self analysisChineseMassyCodeStr:textItem.text];
        textLbl.text = txtStr;
        textLbl.font = [UIFont systemFontOfSize:textItem.fontSize*bili];
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [textLbl addGestureRecognizer:panGesture];

        [self addSubview:textLbl];
        [textLblMArr addObject:textLbl];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self];
}
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    UIView *targetView = touch.view;
    
    [self clearCurView];
    if ([targetView isKindOfClass:[APageImgView class]]) {
        APageImgView *imgView = (APageImgView *)targetView;
        imgView.hasBorder = YES;
        if (_myDelegate && [_myDelegate respondsToSelector:@selector(showImgBottomView)]) {
            [_myDelegate showImgBottomView];
        }
    }else if ([targetView isKindOfClass:[APageTextLabel class]]) {
        APageTextLabel *textLbl = (APageTextLabel *)targetView;
        textLbl.hasBorder = YES;
        if (_myDelegate && [_myDelegate respondsToSelector:@selector(showTextBottomView)]) {
            [_myDelegate showTextBottomView];
        }
    }else {
        [self clearCurView];
    }
}
- (void)clearCurView {
    for (APageImageView *imgV in imgViewMArr) {
        if (imgV.hasBorder) {
            imgV.hasBorder = NO;
        }
    }
    for (APageTextLabel *textLbl in textLblMArr) {
        if (textLbl.hasBorder) {
            textLbl.hasBorder = NO;
        }
    }
}
#pragma mark - 解决中文乱码火星文
- (NSString *) analysisChineseMassyCodeStr:(NSString *)messyCodeStr{
    const char *c = [messyCodeStr cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString *retStr = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
    return retStr;
}

@end
