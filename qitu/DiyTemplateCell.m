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

@interface DiyTemplateCell()
{
    NSMutableArray *imgViewMArr;//成员APageImageView对象
    NSMutableArray *textLblMArr;//成员APageTextLabel对象
    ENUM_DIY_TYPE diyContentType;//背景、图片、文本
    CGPoint originalLocation;
    
    UIView *targetView;//touch move指定编辑的view
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
//                              WithFrame:CGRectMake(imgItem.img_x*bili, imgItem.img_y*bili, imgItem.imgWidth*bili, imgItem.imgHeight*bili)];
        //imgV.borderSize = self.frame.size;
        imgV.myDelegate = self.myDelegate;
        [imgV setImage:[UIImage imageNamed:imgItem.imgStr]];
        
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//        [self addGestureRecognizer:tapGesture];
        [self addSubview:imgV];
        [imgViewMArr addObject:imgV];
    }
    
    for (APageTextItem *txtItem in pageData.textMArr) {
        APageTextLabel *textLbl = [[APageTextLabel alloc] initWithFrame:CGRectMake(txtItem.txt_x*bili, txtItem.txt_y*bili, txtItem.txt_width*bili, txtItem.txt_height*bili)];
        TextItem *textItem = txtItem.textItem;
        textLbl.textColor = [UIColor colorWithHexString:textItem.txtColorHexStr];
        NSString *txtStr = [self analysisChineseMassyCodeStr:textItem.text];
        textLbl.text = txtStr;
        textLbl.font = [UIFont systemFontOfSize:textItem.fontSize*bili];
        [self addSubview:textLbl];
        [textLblMArr addObject:textLbl];
    }
}

//
//-( UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *hitView = [super hitTest:point withEvent:event];
//    if (hitView == self) {
//        return nil; // 是self的时候, 不做处理，由它的父视图处理
//    } else {
//        return hitView; // 是subView的时候,由subView去处理
//    }
//}

#pragma mark - 解决中文乱码火星文
- (NSString *) analysisChineseMassyCodeStr:(NSString *)messyCodeStr{
    const char *c = [messyCodeStr cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString *retStr = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
    return retStr;
}

@end
