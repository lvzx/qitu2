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
        
        CGRect borderRect = CGRectMake(-CREATOR_IMG_PADDING, -CREATOR_IMG_PADDING, frame.size.width+2*CREATOR_IMG_PADDING, frame.size.height+2*CREATOR_IMG_PADDING);
        _borderView = [[TextBorderView alloc] initWithFrame:borderRect];
        _borderView.hidden = YES;
        [self addSubview:_borderView];
    }
    return self;
}

- (void)setHasBorder:(BOOL)hasBorder {
    _borderView.hidden = !hasBorder;
}

@end
