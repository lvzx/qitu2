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


@interface DiyTemplateCell()
{
    NSMutableArray *imgViewMArr;//成员APageImageView对象
    NSMutableArray *textLblMArr;//成员APageTextLabel对象
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
    self.contentView.backgroundColor = [UIColor colorWithHexString:pageData.bgColor];
    [self.backgroundImg sd_setImageWithURL:[NSURL URLWithString:pageData.bgImgUrl]];
    self.numLbl.text = [NSString stringWithFormat:@"%@", @(self.tag-DIY_CELL_TAG+1)];
    CGFloat bili = kScreenWidth/pageData.bgpicwidth;
    
    imgViewMArr = [[NSMutableArray alloc] init];
    textLblMArr = [[NSMutableArray alloc] init];
    for (APageImgItem *imgItem in pageData.imgsMArr) {
        //        APageImgView *imgV = [[APageImgView alloc] initWithFrame:CGRectMake(imgItem.img_x*bili+CREATOR_IMG_PADDING, imgItem.img_y*bili+CREATOR_IMG_PADDING, imgItem.imgWidth*bili+2*CREATOR_IMG_PADDING, 200*bili+2*CREATOR_IMG_PADDING)];
        APageImageView *imgV = [[APageImageView alloc] initWithFrame:CGRectMake(imgItem.img_x*bili, imgItem.img_y*bili, imgItem.imgWidth*bili, imgItem.imgHeight*bili)];
        
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
        [imgViewMArr addObject:imgV];
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
        [textLblMArr addObject:textLbl];
        
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
    [self resetBorderState];
    UIView *targetView = recognizer.view;
    if (targetView) {
//        [borderView removeFromSuperview];
//        [textBorderView removeFromSuperview];
        if ([targetView isKindOfClass:[APageImageView class]]) {
            APageImageView *imgView = (APageImageView *)targetView;
            imgView.hasBorder = YES;
        }else if ([targetView isKindOfClass:[APageTextLabel class]]) {
//            textBorderView.frame = borderRect;
//            [targetView addSubview:textBorderView];
        }
    }
}

- (void)resetBorderState {
    for (APageImageView *imgView in imgViewMArr) {
        imgView.hasBorder = NO;
    }
//    for (APageTextLabel *textLbl in textLblMArr) {
//        
//    }
}

#pragma mark - 视图控制器的触摸事件
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"UIViewController start touch...");
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"UIViewController moving...");
//    
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"UIViewController touch end.");
//}

#pragma mark - 解决中文乱码火星文
- (NSString *) analysisChineseMassyCodeStr:(NSString *)messyCodeStr{
    const char *c = [messyCodeStr cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString *retStr = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
    return retStr;
}

@end
