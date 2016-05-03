//
//  APageTextLabel.m
//  qitu
//
//  Created by 上海企图 on 16/4/18.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageTextLabel.h"
#import "TextBorderView.h"

@interface APageTextLabel ()
@property (nonatomic, strong) TextBorderView *borderView;
@end

@implementation APageTextLabel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)setHasBorder:(BOOL)hasBorder {
    _hasBorder = hasBorder;
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_hasBorder) {
        CGFloat width = rect.size.width-2*CREATOR_IMG_PADDING;
        CGFloat height = rect.size.height-2*CREATOR_IMG_PADDING;
        //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect imgRect = CGRectMake(CREATOR_IMG_PADDING, CREATOR_IMG_PADDING, width, height);
        /*画矩形*/
        CGContextSetLineWidth(context, 1.0);//线的宽度
        UIColor *aColor = RGBCOLOR(61, 171, 252);//blue蓝色
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
        CGContextStrokeRect(context,imgRect);//画方框
        /*画左中、右中圆*/
        CGContextSetFillColorWithColor(context, aColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        aColor = [UIColor whiteColor];
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, CREATOR_IMG_PADDING, height/2.0+CREATOR_IMG_PADDING, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextAddArc(context, width+CREATOR_IMG_PADDING, height/2.0+CREATOR_IMG_PADDING, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

- (void)drawTextInRect:(CGRect)rect {
    CGFloat width = rect.size.width-4*CREATOR_IMG_PADDING;
    CGFloat height = rect.size.height-4*CREATOR_IMG_PADDING;
    CGRect textRect = CGRectMake(CREATOR_IMG_PADDING*2, CREATOR_IMG_PADDING*2, width, height);
    [super drawTextInRect:textRect];
}

@end
