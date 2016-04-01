//
//  ColorRect.h
//  qitu
//
//  Created by 上海企图 on 16/4/1.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorRect
@property (strong, nonatomic) UIColor *color;
@end

@interface ColorRect : UIView<ColorRect>

@end
