//
//  APageImageView.m
//  qitu
//
//  Created by 上海企图 on 16/4/19.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "APageImageView.h"
#import "BorderView.h"

@interface APageImageView ()
@property (nonatomic, strong) BorderView *borderView;
@end

@implementation APageImageView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        
        CGRect borderRect = CGRectMake(-CREATOR_IMG_PADDING, -CREATOR_IMG_PADDING, frame.size.width+2*CREATOR_IMG_PADDING, frame.size.height+2*CREATOR_IMG_PADDING);
        _borderView = [[BorderView alloc] initWithFrame:borderRect];
        _borderView.hidden = YES;
        [self addSubview:_borderView];
    }
    return self;
}

- (void)setHasBorder:(BOOL)hasBorder {
    _borderView.hidden = !hasBorder;
}
@end
