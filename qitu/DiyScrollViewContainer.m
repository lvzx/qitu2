//
//  DiyScrollViewContainer.m
//  qitu
//
//  Created by 上海企图 on 16/4/22.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyScrollViewContainer.h"

@implementation DiyScrollViewContainer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(57, 57, 57);
    }
    return self;
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return _scrollView;
    }
    return view;
}

@end
