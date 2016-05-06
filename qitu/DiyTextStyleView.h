//
//  DiyTextStyleView.h
//  qitu
//
//  Created by 上海企图 on 16/5/6.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyRelatedEnum.h"

@protocol DiyTextStyleViewDelegate <NSObject>

- (void)didSelectTextAlign:(ENUM_DIY_TEXTALIGN)textAlign;
- (void)didSelectBgColor:(NSInteger)colorIdx;

@end

static const CGFloat kTextStyleViewH = 160;
static const CGFloat kColorSelectorH = 65;
static const CGFloat kColorSelectorW = 35;

@interface DiyTextStyleView : UIView
@property (nonatomic, assign) ENUM_DIY_TEXTALIGN textAlign;
@property (nonatomic, assign) NSInteger colorIdx;
@property (nonatomic, strong) UISlider *fontSizeSlider;
@property (assign, nonatomic) id<DiyTextStyleViewDelegate> delegate;

- (instancetype)initWithColors:(NSArray *)colors;

@end
