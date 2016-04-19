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
#import "APageImageView.h"
#import "BorderView.h"
//#import "APageImgView.h"
#import "APageTextLabel.h"
#import "TextBorderView.h"

@interface DiyOnePageCell ()
{
    BorderView *borderView;
    TextBorderView *textBorderView;
}
@property (strong, nonatomic) UIImageView *backgroundImg;

@end

@implementation DiyOnePageCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
        UILabel *numLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, 35, 28)];
        numLbl.textColor = [UIColor whiteColor];
        numLbl.textAlignment = NSTextAlignmentCenter;
        numLbl.text = [NSString stringWithFormat:@"%@", @(self.tag+1)];
        [pageNumV addSubview:numLbl];
        [self addSubview:pageNumV];
    }
    return self;
}

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
        [self addSubview:imgV];
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
        [self addSubview:textLbl];
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

#pragma mark - 解决中文乱码火星文
- (NSString *) analysisChineseMassyCodeStr:(NSString *)messyCodeStr{
    const char *c = [messyCodeStr cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString *retStr = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
    return retStr;
}

@end
