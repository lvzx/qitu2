//
//  ColorRect.m
//  qitu
//
//  Created by 上海企图 on 16/4/1.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "ColorRect.h"

@implementation ColorRect
@synthesize color;

- (void)drawRect:(CGRect)rect {
    CGRect colorRect = CGRectMake(0, 0, CGRectGetWidth(rect), CGRectGetHeight(rect));
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect:colorRect];
    [rectanglePath closePath];
    [self.color setFill];
    [rectanglePath fill];
}
@end
