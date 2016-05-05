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
#import "DiyRelatedEnum.h"

@interface DiyOnePageCell ()
{
    NSMutableArray *imgViewMArr;//成员APageImageView对象
    NSMutableArray *textLblMArr;//成员APageTextLabel对象
    ENUM_DIY_TYPE diyContentType;//背景、图片、文本
    CGPoint originalLocation;
    
    APageImgView *selImgView;
    APageTextLabel *selTextLbl;
    
    BOOL isUpdate;//标识是否有更新，需要保存
    
    //UIView *targetView;//touch move指定编辑的view
}
@property (strong, nonatomic) UIImageView *backgroundImg;
@property (strong, nonatomic) UILabel *numLbl;
@end

@implementation DiyOnePageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        //self.contentView.layer.borderWidth = 0.8;
        //self.contentView.layer.borderColor = RGBCOLOR(213, 213, 213).CGColor;
        self.backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.backgroundImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.backgroundImg addGestureRecognizer:tapGesture];
        [self.contentView addSubview:self.backgroundImg];
        
        UIView *pageNumV = [[UIView alloc] initWithFrame:CGRectMake(width-35, height-35, 35, 35)];
        pageNumV.backgroundColor = [UIColor blackColor];
        pageNumV.alpha = 0.25;
        _numLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 35, 28)];
        _numLbl.textColor = [UIColor whiteColor];
        _numLbl.textAlignment = NSTextAlignmentCenter;
        _numLbl.text = [NSString stringWithFormat:@"%@", @(self.tag+1)];
        [pageNumV addSubview:_numLbl];
        [self.contentView addSubview:pageNumV];
    }
    return self;
}

- (void)setAPageItem:(DiyAPageItem *)aPageItem {
    if (_aPageItem != aPageItem) {
        _aPageItem = aPageItem;
    }
    self.backgroundImg.backgroundColor = [UIColor colorWithHexString:aPageItem.bgColor];
    [self.backgroundImg sd_setImageWithURL:[NSURL URLWithString:aPageItem.bgImgUrl]];
    self.numLbl.text = [NSString stringWithFormat:@"%@", @(self.tag-DIY_CELL_TAG+1)];
    //*[UIScreen mainScreen].scale
    CGFloat bili = kScreenWidth/aPageItem.bgpicwidth;
    
    imgViewMArr = [[NSMutableArray alloc] init];
    textLblMArr = [[NSMutableArray alloc] init];
    NSInteger imgRow = 0;
    for (APageImgItem *imgItem in aPageItem.imgsMArr) {
        CGRect imgRect = CGRectMake(imgItem.img_x*bili-CREATOR_IMG_PADDING, imgItem.img_y*bili-CREATOR_IMG_PADDING, imgItem.imgWidth*bili+2*CREATOR_IMG_PADDING, imgItem.imgHeight*bili+2*CREATOR_IMG_PADDING);
        APageImgView *imgV = [[APageImgView alloc] initWithFrame:imgRect];
        imgV.imgItem = imgItem;
        imgRow++;
        imgV.tag = kCellElementTag+imgRow;
        imgV.myDelegate = self.myDelegate;
        [imgV setImage:[UIImage imageNamed:imgItem.imgStr]];
        [self.contentView addSubview:imgV];
        [imgViewMArr addObject:imgV];
    }
    
    for (APageTextItem *txtItem in aPageItem.textMArr) {
        TextItem *textItem = txtItem.textItem;
        NSString *txtStr = [self analysisChineseMassyCodeStr:textItem.text];
        UIFont *textFont = [UIFont systemFontOfSize:textItem.fontSize*bili];
        CGFloat textWidth = txtItem.txt_width*bili+2*CREATOR_IMG_PADDING;
        CGSize textSize = [self boundingRectText:txtStr WithFont:textFont withSize:CGSizeMake(textWidth, 800)];
        APageTextLabel *textLbl = [[APageTextLabel alloc] initWithFrame:CGRectMake(txtItem.txt_x*bili-CREATOR_IMG_PADDING, txtItem.txt_y*bili, textWidth, textSize.height+2*CREATOR_BORDER_WIDTH)];
         NSLog(@"textSize:%@, textRect:%@, textFont:%@", NSStringFromCGSize(textSize), NSStringFromCGRect(textLbl.frame), textFont);
        textLbl.myDelegate = self.myDelegate;
        textLbl.textColor = [UIColor colorWithHexString:textItem.txtColorHexStr];
        textLbl.text = txtStr;
        textLbl.font = textFont;
        [self.contentView addSubview:textLbl];
        [textLblMArr addObject:textLbl];
    }
}

-(CGSize)boundingRectText:(NSString *)str WithFont:(UIFont *)font withSize:(CGSize)size
{
    if (!font) {
        font = [UIFont systemFontOfSize:15.0];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [str boundingRectWithSize:size
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
}

/*
- (void)initCellWithData:(DiyAPageItem *)pageData {
    self.contentView.backgroundColor = [UIColor colorWithHexString:pageData.bgColor];
    [self.backgroundImg sd_setImageWithURL:[NSURL URLWithString:pageData.bgImgUrl]];
    
    CGFloat bili = kScreenWidth/(pageData.bgpicwidth/2);
    
    for (APageImgItem *imgItem in pageData.imgsMArr) {
//        APageImgView *imgV = [[APageImgView alloc] initWithFrame:CGRectMake(imgItem.img_x*bili+CREATOR_IMG_PADDING, imgItem.img_y*bili+CREATOR_IMG_PADDING, imgItem.imgWidth*bili+2*CREATOR_IMG_PADDING, 200*bili+2*CREATOR_IMG_PADDING)];
        APageImageView *imgV = [[APageImageView alloc] initWithFrame:CGRectMake(imgItem.img_x*bili, imgItem.img_y*bili, imgItem.imgWidth*bili, 200*bili)];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePan:)];
        [imgV addGestureRecognizer:panGestureRecognizer];
        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]
                                                            initWithTarget:self
                                                            action:@selector(handlePinch:)];
        [imgV addGestureRecognizer:pinchGestureRecognizer];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imgV addGestureRecognizer:tapGestureRecognizer];
        //[imgV initImgViewWith:imgItem];
        [imgV setImage:[UIImage imageNamed:imgItem.imgStr]];
        [self.contentView addSubview:imgV];
    }
    
    for (APageTextItem *txtItem in pageData.textMArr) {
        APageTextLabel *textLbl = [[APageTextLabel alloc] initWithFrame:CGRectMake(txtItem.txt_x*bili, txtItem.txt_y*bili, txtItem.txt_width*bili, txtItem.txt_height*bili)];
        TextItem *textItem = txtItem.textItem;
        textLbl.textColor = [UIColor colorWithHexString:textItem.txtColorHexStr];
        NSString *txtStr = [self analysisChineseMassyCodeStr:textItem.text];
        textLbl.text = txtStr;
        textLbl.font = [UIFont systemFontOfSize:textItem.fontSize*bili];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handlePan:)];
        [textLbl addGestureRecognizer:panGestureRecognizer];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [textLbl addGestureRecognizer:tapGestureRecognizer];
        [self.contentView addSubview:textLbl];
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
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
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    UIView *targetView = recognizer.view;
    CGRect frame = targetView.frame;
    NSLog(@"$$$$$%@", targetView);
    CGRect borderRect = CGRectMake(-CREATOR_IMG_PADDING, -CREATOR_IMG_PADDING, frame.size.width+2*CREATOR_IMG_PADDING, frame.size.height+2*CREATOR_IMG_PADDING);
    if (borderView == nil) {
        borderView = [[BorderView alloc] initWithFrame:CGRectZero];
    }
    if (textBorderView == nil) {
        textBorderView = [[TextBorderView alloc] initWithFrame:CGRectZero];
    }

    if (targetView) {
        [borderView removeFromSuperview];
        [textBorderView removeFromSuperview];
        if ([targetView isKindOfClass:[APageImageView class]]) {
            borderView.frame = borderRect;
            [targetView addSubview:borderView];
        }else if ([targetView isKindOfClass:[APageTextLabel class]]) {
            textBorderView.frame = borderRect;
            [targetView addSubview:textBorderView];
        }
    }
}
*/
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(showMainBottomView:)]) {
        [_myDelegate showMainBottomView:self];
    }
}
#pragma mark - 解决中文乱码火星文
- (NSString *) analysisChineseMassyCodeStr:(NSString *)messyCodeStr{
    const char *c = [messyCodeStr cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString *retStr = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
    return retStr;
}

@end
