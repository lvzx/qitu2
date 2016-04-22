//
//  APageImgView.m
//  qitu
//
//  Created by 上海企图 on 16/4/21.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageImgView.h"

//static const CGFloat kMinimumScaleArea = 60;
//static const CGFloat kScaleBorderDotArea = 16;
////static const CGFloat kMinOffset = 2;
//
//static CGFloat distanceBetweenPoints(CGPoint point0, CGPoint point1)
//{
//    return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2));
//}

@interface APageImgView ()
{
    CGRect imgRect;
    CGPoint orginalPoint;//移动开始时起点
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
    }
    return self;
}

//覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    /*画图片*/
    CGFloat width = rect.size.width-2*CREATOR_IMG_PADDING;
    CGFloat height = rect.size.height-2*CREATOR_IMG_PADDING;
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
        CGContextAddArc(context, CREATOR_IMG_PADDING, CREATOR_IMG_PADDING, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextAddArc(context, width+CREATOR_IMG_PADDING, CREATOR_IMG_PADDING, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextAddArc(context, CREATOR_IMG_PADDING, height+CREATOR_IMG_PADDING, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextAddArc(context, width+CREATOR_IMG_PADDING, height+CREATOR_IMG_PADDING, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke); //绘制路径
    }
}

- (void)setHasBorder:(BOOL)hasBorder {
    _hasBorder = hasBorder;
    [self setNeedsDisplay];
}
/*
#pragma mark - 视图触摸事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    orginalPoint = [touch locationInView:self];
    panBeginPoint = orginalPoint;
    self.hasBorder = YES;
    
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(showImgBottomView)]) {
        [_myDelegate showImgBottomView];
    }
    NSLog(@"touch Original:%@", NSStringFromCGPoint(orginalPoint));
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if ([touches count] == 1) {
        CGPoint curPoint = [touch locationInView:self];
        CGRect destFrame = self.frame;
        NSLog(@"curFrame:%@, curPoint:%@", NSStringFromCGRect(destFrame), NSStringFromCGPoint(curPoint));
        //四个角的位置
        CGFloat targetW = destFrame.size.width;
        CGFloat targetH = destFrame.size.height;
        
        CGPoint p0 = CGPointMake(CREATOR_IMG_PADDING, CREATOR_IMG_PADDING);//左上角坐标
        CGPoint p1 = CGPointMake(CREATOR_IMG_PADDING, targetH-CREATOR_IMG_PADDING);//左下角坐标
        CGPoint p2 = CGPointMake(targetW-CREATOR_IMG_PADDING, CREATOR_IMG_PADDING);//右上角坐标
        CGPoint p3 = CGPointMake(targetW-CREATOR_IMG_PADDING, targetH-CREATOR_IMG_PADDING);//右下角坐标
        
        BOOL canChangeWidth = imgRect.size.width > kMinimumScaleArea;
        BOOL canChangeHeight = imgRect.size.height > kMinimumScaleArea;
        NSLog(@"p0:%@, p1:%@, p2:%@, p3:%@", NSStringFromCGPoint(p0), NSStringFromCGPoint(p1), NSStringFromCGPoint(p2), NSStringFromCGPoint(p3));
        //分别计算x，和y方向上的移动
        offsetX = curPoint.x - orginalPoint.x;
        offsetY = curPoint.y - orginalPoint.y;
        
        if (distanceBetweenPoints(curPoint, p0) < kScaleBorderDotArea) {
            if (canChangeWidth) {
                destFrame.origin.x += offsetX;
                destFrame.size.width -= offsetX;
            }
            if (canChangeHeight) {
                destFrame.origin.y += offsetY;
                destFrame.size.height -= offsetY;
            }
            
            self.frame = destFrame;
        }else if (distanceBetweenPoints(curPoint, p1) < kScaleBorderDotArea) {
            if (canChangeWidth) {
                destFrame.origin.x += offsetX;
                destFrame.size.width -= offsetX;
            }
            if (canChangeHeight) {
                destFrame.origin.y += offsetY;
                destFrame.size.height -= offsetY;
            }
            self.frame = destFrame;
        }else if (distanceBetweenPoints(curPoint, p2) < kScaleBorderDotArea) {
            if (canChangeWidth) {
                destFrame.size.width += offsetX;
            }
            if (canChangeHeight) {
                destFrame.size.height += offsetY;
            }
            self.frame = destFrame;
        }else if (distanceBetweenPoints(curPoint, p3) < kScaleBorderDotArea) {
            if (canChangeWidth) {
                destFrame.size.width += offsetX;
            }
            if (canChangeHeight) {
                destFrame.size.height += offsetY;
            }
            self.frame = destFrame;
        }else {
            
            orginalCenter.x += (curPoint.x - panBeginPoint.x);
            orginalCenter.y += (curPoint.y - panBeginPoint.y);
            self.center = orginalCenter;
        }
        
        orginalPoint = curPoint;
    }
}
*/
@end
