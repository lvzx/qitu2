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
#import "APageTextLabel.h"

@interface DiyTemplateCell()
{
    NSMutableArray *imgViewMArr;//成员APageImageView对象
    NSMutableArray *textLblMArr;//成员APageTextLabel对象
    
    CGPoint originalLocation;
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
        APageImageView *imgV = [[APageImageView alloc] initWithFrame:CGRectMake(imgItem.img_x*bili, imgItem.img_y*bili, imgItem.imgWidth*bili, imgItem.imgHeight*bili)];
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
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    
}

- (void)resetBorderState {
    for (APageImageView *imgView in imgViewMArr) {
        imgView.hasBorder = NO;
    }
    for (APageTextLabel *textLbl in textLblMArr) {
        textLbl.hasBorder = NO;
    }
}

#pragma mark - 视图控制器的触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resetBorderState];
    UITouch *touch = [touches anyObject];
    originalLocation = [touch locationInView:self];
    UIView *targetView = touch.view;
    if (targetView) {
        if ([targetView isKindOfClass:[APageImageView class]]) {
            APageImageView *imgView = (APageImageView *)targetView;
            imgView.hasBorder = YES;
            if (_myDelegate && [_myDelegate respondsToSelector:@selector(showImgBottomView)]) {
                [_myDelegate showImgBottomView];
            }
        }else if ([targetView isKindOfClass:[APageTextLabel class]]) {
            APageTextLabel *txtLbl = (APageTextLabel *)targetView;
            txtLbl.hasBorder = YES;
        }
    }
    
    NSLog(@"UIViewController start touch...targetView:%@, touch:%@, event%@", targetView, touch, event);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"UIViewController moving...");
//    UITouch *touch = [touches anyObject];
//    CGPoint currentLocation = [touch locationInView:self];
//    CGRect frame = self.view.frame;
//    frame.origin.x += currentLocation.x-originalLocation.x;
//    frame.origin.y += currentLocation.y-originalLocation.y;
//    self.view.frame = frame;
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        
    }
    NSLog(@"UIViewController touch end.");
}

#pragma mark - 解决中文乱码火星文
- (NSString *) analysisChineseMassyCodeStr:(NSString *)messyCodeStr{
    const char *c = [messyCodeStr cStringUsingEncoding:NSISOLatin1StringEncoding];
    NSString *retStr = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
    return retStr;
}

@end
