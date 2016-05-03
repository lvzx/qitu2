//
//  APageImgView.m
//  qitu
//
//  Created by 上海企图 on 16/4/21.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageImgView.h"

//static const CGFloat kMinimumScaleArea = 40;
static const CGFloat kScaleBorderDotArea = 25;
//static const CGFloat kMinOffset = 2;

static CGFloat distanceBetweenPoints(CGPoint point0, CGPoint point1)
{
    return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2));
}

typedef enum {
    ENUM_LEFT_TOP_POINT = 20,
    ENUM_LEFT_BOTTOM_POINT,
    ENUM_RIGHT_TOP_POINT,
    ENUM_RIGHT_BOTTOM_POINT,
    ENUM_CENTER_POINT
}ENUM_ACTION_TYPE;

@interface APageImgView ()
{
    CGRect imgRect;
    CGPoint orginalPoint;//移动开始时起点
    
    CGFloat pLeft;
    CGFloat pRight;
    CGFloat pBottom;
    CGFloat pTop;
    CGPoint pCenter;
    
    ENUM_ACTION_TYPE actionStyle;
    
    CGFloat orginalScale;//图片初始宽高比例
    CGPoint panBeginPoint;
    CGPoint orginalCenter;
    CGFloat offsetX, offsetY;//移动时x,y方向上的偏移量
}
@end

@implementation APageImgView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        orginalScale = frame.size.height/frame.size.width;
    }
    return self;
}

//覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    /*画图片*/
    CGFloat width = rect.size.width-2*CREATOR_IMG_PADDING;
    CGFloat height = rect.size.height-2*CREATOR_IMG_PADDING;
    pCenter = CGPointMake(width/2+CREATOR_IMG_PADDING, height/2+CREATOR_IMG_PADDING);
    imgRect = CGRectMake(CREATOR_IMG_PADDING, CREATOR_IMG_PADDING, width, height);
    if (_image) {
        [_image drawInRect:imgRect];
    }

    if (_hasBorder) {
        NSLog(@"****%f", rect.size.width);
        //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        /*画矩形*/
        CGContextSetLineWidth(context, 1.0);//线的宽度
        UIColor *aColor = RGBCOLOR(61, 171, 252);//blue蓝色
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
        CGContextStrokeRect(context,imgRect);//画方框
        
        /*画左上角、左下角、右上角、右下角圆*/
        CGContextSetFillColorWithColor(context, aColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        aColor = [UIColor whiteColor];
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        pLeft = CREATOR_IMG_PADDING;
        pRight = width+CREATOR_IMG_PADDING;
        pBottom = height+CREATOR_IMG_PADDING;
        pTop = CREATOR_IMG_PADDING;
        CGContextAddArc(context, pLeft, pTop, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextAddArc(context, pRight, pTop, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextAddArc(context, pLeft, pBottom, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextAddArc(context, pRight, pBottom, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    }
}

- (void)setHasBorder:(BOOL)hasBorder {
    _hasBorder = hasBorder;
    [self setNeedsDisplay];
}

- (void)updateImage:(UIImage *)image withSize:(CGSize)size {
    _image = image;
    self.bounds = CGRectMake(0, 0, size.width+2*CREATOR_IMG_PADDING, size.height+2*CREATOR_IMG_PADDING);
    [self setNeedsDisplay];
}

#pragma mark - 视图触摸事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alpha = 1.0;
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self];
    orginalPoint = curPoint;
    self.hasBorder = YES;
    
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(showImgBottomView:)]) {
        [_myDelegate showImgBottomView:self];
    }
    CGPoint p0 = CGPointMake(pLeft, pTop);//左上角坐标
    CGPoint p1 = CGPointMake(pLeft, pBottom);//左下角坐标
    CGPoint p2 = CGPointMake(pRight, pTop);//右上角坐标
    CGPoint p3 = CGPointMake(pRight, pBottom);//右下角坐标
    
    if (distanceBetweenPoints(curPoint, p0) < kScaleBorderDotArea) {
        
        actionStyle = ENUM_LEFT_TOP_POINT;
        
    }else if (distanceBetweenPoints(curPoint, p1) < kScaleBorderDotArea) {
        
        actionStyle = ENUM_LEFT_BOTTOM_POINT;
        
    }else if (distanceBetweenPoints(curPoint, p2) < kScaleBorderDotArea) {
        
        actionStyle = ENUM_RIGHT_TOP_POINT;
        
    }else if (distanceBetweenPoints(curPoint, p3) < kScaleBorderDotArea) {
        
        actionStyle = ENUM_RIGHT_BOTTOM_POINT;
        
    }else{
        
        actionStyle = ENUM_CENTER_POINT;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alpha = 0.7;
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self];
    CGRect destFrame = self.frame;
    NSLog(@"curFrame:%@, curPoint:%@, orginalPoint:%@", NSStringFromCGRect(destFrame), NSStringFromCGPoint(curPoint), NSStringFromCGPoint(orginalPoint));
    
    //分别计算x，和y方向上的移动
    offsetX = curPoint.x - orginalPoint.x;
    offsetY = curPoint.y - orginalPoint.y;
    offsetY = orginalScale*offsetX;
    
    switch (actionStyle) {
        case ENUM_LEFT_TOP_POINT:
        {
            destFrame.origin.x += offsetX;
            destFrame.size.width -= offsetX;
            destFrame.origin.y += offsetY;
            destFrame.size.height -= offsetY;
            
            self.frame = destFrame;
        }
            break;
        case ENUM_LEFT_BOTTOM_POINT:
        {
            destFrame.origin.x += offsetX;
            destFrame.size.width -= offsetX;
            destFrame.size.height -= offsetY;
            self.frame = destFrame;
        }
            break;
        case ENUM_RIGHT_TOP_POINT:
        {
            destFrame.size.width += offsetX;
            destFrame.size.height += offsetY;
            destFrame.origin.y -= offsetY;
            self.frame = destFrame;
        }
            break;
        case ENUM_RIGHT_BOTTOM_POINT:
        {
            destFrame.size.width += offsetX;
            destFrame.size.height += offsetY;
            self.frame = destFrame;
        }
            break;
        case ENUM_CENTER_POINT:
        {
            self.center = [touch locationInView:self.superview];
        }
            break;
        default:
            break;
    }
    
    orginalPoint = curPoint;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.alpha = 1.0;
}
@end
