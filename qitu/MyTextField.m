//
//  MyTextField.m
//  qitu
//
//  Created by 上海企图 on 16/3/23.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

- (void)_setup {
    [self setBorderStyle:UITextBorderStyleNone];
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self _setup];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    
    [layer setBorderWidth: 1.0];
    [layer setBorderColor: [UIColor grayColor].CGColor];
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    [layer setCornerRadius:3.0];
    [layer setShadowOpacity:1.0];
    [layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [layer setShadowOffset:CGSizeMake(1.0, 1.0)];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 10, 4);
}

// text position while editing
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    return CGRectInset(bounds, 10, 4);
}

//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    CGRect leftRect = [super placeholderRectForBounds:bounds];
//    leftRect.origin.x += 10.0;
//    return leftRect;
//}

//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_0
//- (void) drawPlaceholderInRect:(CGRect)rect {
//    
//    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:17], NSForegroundColorAttributeName : [UIColor colorWithRed:182/255. green:182/255. blue:183/255. alpha:1.0]};
//    [self.placeholder drawInRect:CGRectInset(rect, 5, 5) withAttributes:attributes];
//}
//#endif

@end
