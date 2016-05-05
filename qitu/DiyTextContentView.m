//
//  DiyTextContentView.m
//  qitu
//
//  Created by 上海企图 on 16/5/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "DiyTextContentView.h"
static const NSInteger kOKBtnHeight = 30;
@implementation DiyTextContentView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = RGBCOLOR(213, 213, 213).CGColor;
        self.layer.borderWidth = 1.0f;
        [self addSubview:self.textTV];
        [self addSubview:self.okBtn];
    }
    return self;
}
- (UITextView *)textTV {
    if (_textTV == nil) {
        _textTV = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - kOKBtnHeight)];
        _textTV.inputAccessoryView = [[UIView alloc] init];
    }
    return _textTV;
}
- (UIButton *)okBtn {
    if (_okBtn == nil) {
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-50, self.bounds.size.height-30, 50, 30)];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:RGBCOLOR(83, 189, 173) forState:UIControlStateNormal];

    }
    return _okBtn;
}
- (void)setDiyTextContentHandler:(id)target selector:(SEL)aSelector {
    _textTV.delegate = target;
    [_okBtn addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
}
@end
