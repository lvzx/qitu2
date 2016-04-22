//
//  APageImageView.m
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageImageView.h"
//#import "BorderView.h"
//

static const CGFloat kMinimumScaleArea = 20;
static const CGFloat kScaleBorderDotArea = 12;

static CGFloat distanceBetweenPoints(CGPoint point0, CGPoint point1)
{
    return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2));
}

@interface APageImageView ()
{
    CGPoint orginalPoint;
    CGPoint orginalCenter;
    CGFloat offsetX, offsetY;//移动时x,y方向上的偏移量
}
@end

@implementation APageImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setExclusiveTouch:YES];
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//        [self addGestureRecognizer:panGesture];
//        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//        [self addGestureRecognizer:pinchGesture];
    }
    return self;
}

- (void)setHasBorder:(BOOL)hasBorder {
    _hasBorder = hasBorder;
    if (_hasBorder) {
        UIColor *aColor = RGBCOLOR(61, 171, 252);//blue蓝色
        self.layer.borderColor = aColor.CGColor;
        self.layer.borderWidth = 2.0;
    }else {
        self.layer.borderWidth = 0.0;
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    CGFloat destX,destY,destW,destH;
    destX = recognizer.view.center.x + translation.x;
    destY = recognizer.view.center.y + translation.y;
    destW = self.frame.size.width;
    destH = self.frame.size.height;
    if (destX < destW/2) {//左边界越界处理
        destX = destW/2;
    }
    if (destY < destH/2) {//上边界越界处理
        destY = destH/2;
    }
    if (destX+destW/2 > _borderSize.width) {//右边界越界处理
        destX = _borderSize.width-destW/2;
    }
    if (destY+destH/2 > _borderSize.height) {//右边界越界处理
        destY = _borderSize.height-destH/2;
    }
    recognizer.view.center = CGPointMake(destX, destY);
    [recognizer setTranslation:CGPointZero inView:self];
}
- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    NSLog(@"recoginizer:%@", recognizer.view);
//    CGFloat destX,destY,destW,destH;
//    destX = recognizer.view.frame.origin.x;
//    destY = recognizer.view.frame.origin.y;
//    destW = recognizer.view.frame.size.width;
//    destH = recognizer.view.frame.size.height;
//    if (destX < 0) {//左边界越界处理
//        destX = 0;
//    }
//    if (destY < 0) {//上边界越界处理
//        destY = 0;
//    }
//    if (destX+destW > _borderSize.width) {//右边界越界处理
//        destX = _borderSize.width-destW;
//    }
//    if (destY+destH > _borderSize.height) {//右边界越界处理
//        destY = _borderSize.height-destH;
//    }
//    
//    CGRect rect = CGRectMake(destX, destY, destW, destY);
//    recognizer.view.frame = rect;
}

#pragma mark - 视图触摸事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    orginalPoint = [touch locationInView:self];
    orginalCenter = self.center;
    self.hasBorder = YES;
    NSLog(@"touch Original:%@, orginalCenter:%@, borderSize:%@", NSStringFromCGPoint(orginalPoint), NSStringFromCGPoint(orginalCenter), NSStringFromCGSize(_borderSize));
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
        
        CGPoint p0 = CGPointMake(0, 0);//左上角坐标
        CGPoint p1 = CGPointMake(0, targetW);//左下角坐标
        CGPoint p2 = CGPointMake(targetW, 0);//右上角坐标
        CGPoint p3 = CGPointMake(targetW, targetH);//右下角坐标
        
        BOOL canChangeWidth = destFrame.size.width > kMinimumScaleArea;
        BOOL canChangeHeight = destFrame.size.height > kMinimumScaleArea;
        
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
                destFrame.size.width += offsetX;
            }
            if (canChangeHeight) {
                destFrame.origin.y += offsetY;
                destFrame.size.height -= offsetY;
            }
            self.frame = destFrame;
        }else if (distanceBetweenPoints(curPoint, p2) < kScaleBorderDotArea) {
            if (canChangeWidth) {
                destFrame.origin.x += offsetX;
                destFrame.size.width -= offsetX;
            }
            if (canChangeHeight) {
                destFrame.size.height += offsetY;
            }
            self.frame = destFrame;
        }else if (distanceBetweenPoints(curPoint, p3) < kScaleBorderDotArea) {
            if (canChangeWidth) {
                destFrame.origin.x += offsetX;
                destFrame.size.width -= offsetX;
            }
            if (canChangeHeight) {
                destFrame.origin.y += offsetY;
                destFrame.size.height -= offsetY;
            }
            self.frame = destFrame;
        }else {
            orginalCenter.x += offsetX;
            orginalCenter.y += offsetY;
            self.center = orginalCenter;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

}
@end
