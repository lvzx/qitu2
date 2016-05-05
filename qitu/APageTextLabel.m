//
//  APageTextLabel.m
//  qitu
//
//  Created by 上海企图 on 16/4/18.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageTextLabel.h"
#import "TextBorderView.h"

static const CGFloat kScaleBorderDotArea = 25;

static CGFloat distanceBetweenPoints(CGPoint point0, CGPoint point1)
{
    return sqrt(pow(point1.x - point0.x, 2) + pow(point1.y - point0.y, 2));
}

typedef enum {
    ENUM_LEFT_MID_POINT = 20,
    ENUM_RIGHT_MID_POINT,
    ENUM_CENTER_POINT
}ENUM_ACTION_TYPE;

@interface APageTextLabel ()
{
    BOOL moved;
    
    UIEdgeInsets _contentInset;
    CGSize textSize;
    
    CGPoint orginalPoint;
    
    CGFloat pLeft;
    CGFloat pRight;
    CGFloat pTop;
    
    ENUM_ACTION_TYPE actionStyle;
}
@property (nonatomic, strong) TextBorderView *borderView;
@end

@implementation APageTextLabel
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        self.numberOfLines = 0;
        self.textAlignment = NSTextAlignmentCenter;
        _contentInset = UIEdgeInsetsMake(CREATOR_BORDER_WIDTH, CREATOR_IMG_PADDING, CREATOR_BORDER_WIDTH, CREATOR_IMG_PADDING);
        textSize = CGSizeZero;
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
        CGFloat height = rect.size.height-2*CREATOR_BORDER_WIDTH;
        //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGRect textRect = CGRectMake(CREATOR_IMG_PADDING, 0, width, height);
        /*画矩形*/
        CGContextSetLineWidth(context, CREATOR_BORDER_WIDTH);//线的宽度
        UIColor *aColor = RGBCOLOR(61, 171, 252);//blue蓝色
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);//线框颜色
        CGContextStrokeRect(context,textRect);//画方框
        
        pLeft = CREATOR_IMG_PADDING;
        pRight = width+CREATOR_IMG_PADDING;
        pTop = height/2.0;
        
        /*画左中、右中圆*/
        CGContextSetFillColorWithColor(context, aColor.CGColor);
        CGContextSetLineWidth(context, CREATOR_BORDER_WIDTH);
        aColor = [UIColor whiteColor];
        CGContextSetStrokeColorWithColor(context, aColor.CGColor);
        // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
        CGContextAddArc(context, pLeft, pTop, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFillStroke);
        CGContextAddArc(context, pRight, pTop, CREATOR_IMG_RADIUS, 0, 2*M_PI, 0);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

- (void)setup {
    [self setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    [self setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat targetWidth = CGRectGetWidth(self.bounds);
    
    if (self.preferredMaxLayoutWidth != targetWidth) {
        self.preferredMaxLayoutWidth = targetWidth;
    }
    [self.superview setNeedsLayout];
}
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, _contentInset) limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x -= _contentInset.left;
    rect.origin.y -= _contentInset.top;
    rect.size.width += (_contentInset.left + _contentInset.right);
    rect.size.height += (_contentInset.top + _contentInset.bottom);
    
    return rect;
}
- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _contentInset)];
}

- (CGFloat)getTextHeightFromWidth:(CGFloat)width {
    CGSize size = CGSizeMake(width-2*CREATOR_IMG_PADDING, 800);
    NSDictionary *attribute = @{NSFontAttributeName: self.font};
    
    CGSize retSize = [self.text boundingRectWithSize:size
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    CGFloat txtHeight = retSize.height+2*CREATOR_BORDER_WIDTH;
    return txtHeight;
}

#pragma mark - 视图触摸事件处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self];
    orginalPoint = [touch locationInView:self.superview];
    
    self.hasBorder = YES;
    NSLog(@"touch begin");
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(showTextBottomView:)]) {
        [_myDelegate showTextBottomView:self];
    }
    
    CGPoint p0 = CGPointMake(pLeft, pTop);//左中圆坐标
    CGPoint p1 = CGPointMake(pRight, pTop);//右中圆坐标
    
    if (distanceBetweenPoints(curPoint, p0) < kScaleBorderDotArea) {
        
        actionStyle = ENUM_LEFT_MID_POINT;
        
    }else if (distanceBetweenPoints(curPoint, p1) < kScaleBorderDotArea) {
        
        actionStyle = ENUM_RIGHT_MID_POINT;
        
    }else{
        actionStyle = ENUM_CENTER_POINT;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    moved = YES;
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self.superview];
    CGRect destFrame = self.frame;
    
    //计算x方向上的移动
    CGFloat offsetX = curPoint.x - orginalPoint.x;

    switch (actionStyle) {
        case ENUM_LEFT_MID_POINT:
        {
            destFrame.origin.x += offsetX;
            destFrame.size.width -= offsetX;
            destFrame.size.height = [self getTextHeightFromWidth:destFrame.size.width];
            self.frame = destFrame;
        }
            break;
        case ENUM_RIGHT_MID_POINT:
        {
            destFrame.size.width += offsetX;
            destFrame.size.height = [self getTextHeightFromWidth:destFrame.size.width];
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
    
    if (moved) {
        
        NSLog(@"***touchEnded-ApageImgView");
    }
}

@end
