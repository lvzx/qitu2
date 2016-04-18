//
//  APageImgView.m
//  qitu
//
//  Created by 上海企图 on 16/4/18.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageImgView.h"

@implementation APageImgView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect imgRect = CGRectMake(6, 6, frame.size.width, frame.size.height);
        self.borderView = [[BorderView alloc] initWithFrame:imgRect];
        [self addSubview:_borderView];
    }
    return self;
}
@end
