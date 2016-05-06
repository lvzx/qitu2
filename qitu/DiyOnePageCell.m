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
    CGFloat width, height;
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
        width = frame.size.width;
        height = frame.size.height;
    }
    return self;
}

- (void)setAPageItem:(DiyAPageItem *)aPageItem {
    if (_aPageItem != aPageItem) {
        _aPageItem = aPageItem;
    }
    if (_aPageItem.pageType == DIY_PAGETYPE_SHOW) {
        _addView = nil;
        self.backgroundImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.backgroundImg.backgroundColor = [UIColor colorWithHexString:aPageItem.bgColor];
        [self.backgroundImg sd_setImageWithURL:[NSURL URLWithString:aPageItem.bgImgUrl]];
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
        self.numLbl.text = [NSString stringWithFormat:@"%@", @(self.tag-DIY_CELL_TAG+1)];
        [pageNumV addSubview:_numLbl];
        [self.contentView addSubview:pageNumV];
        
        //*[UIScreen mainScreen].scale
        CGFloat bili = kScreenWidth/aPageItem.bgpicwidth;
        
        imgViewMArr = [[NSMutableArray alloc] init];
        textLblMArr = [[NSMutableArray alloc] init];
        NSInteger arrIndex = 0;
        for (APageImgItem *imgItem in aPageItem.imgsMArr) {
            arrIndex++;
            CGRect imgRect = CGRectMake(imgItem.img_x*bili-CREATOR_IMG_PADDING, imgItem.img_y*bili-CREATOR_IMG_PADDING, imgItem.imgWidth*bili+2*CREATOR_IMG_PADDING, imgItem.imgHeight*bili+2*CREATOR_IMG_PADDING);
            APageImgView *imgV = [[APageImgView alloc] initWithFrame:imgRect];
            //下面两个元素的赋值顺序不能改变
            imgV.imgIdx = arrIndex;
            imgV.pageItem = aPageItem;
            
            imgV.myDelegate = self.myDelegate;
            [imgV setImage:[UIImage imageNamed:imgItem.imgStr]];
            [self.contentView addSubview:imgV];
            [imgViewMArr addObject:imgV];
        }
        
        arrIndex = 0;
        for (APageTextItem *txtItem in aPageItem.textMArr) {
            arrIndex++;
            TextItem *textItem = txtItem.textItem;
            NSString *txtStr = [self analysisChineseMassyCodeStr:textItem.text];
            UIFont *textFont = [UIFont systemFontOfSize:textItem.fontSize*bili];
            CGFloat textWidth = txtItem.txt_width*bili+2*CREATOR_IMG_PADDING;
            CGSize textSize = [self boundingRectText:txtStr WithFont:textFont withSize:CGSizeMake(textWidth, 800)];
            APageTextLabel *textLbl = [[APageTextLabel alloc] initWithFrame:CGRectMake(txtItem.txt_x*bili-CREATOR_IMG_PADDING, txtItem.txt_y*bili, textWidth, textSize.height+2*CREATOR_BORDER_WIDTH)];
            
            textLbl.myDelegate = self.myDelegate;
            textLbl.textColor = [UIColor colorWithHexString:textItem.txtColorHexStr];
            textLbl.text = txtStr;
            textLbl.font = textFont;
            [self.contentView addSubview:textLbl];
            [textLblMArr addObject:textLbl];
        }
    }else {
        _addView = [[DiyAddPageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_addView];
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
