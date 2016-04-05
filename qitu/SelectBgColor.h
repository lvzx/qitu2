//
//  SelectBgColor.h
//  qitu
//
//  Created by 上海企图 on 16/4/1.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SelectBgColorDelegate<NSObject>
- (void)didSelectBgColor:(NSInteger)colorIdx;
@end

@interface SelectBgColor : UIView
@property (assign, nonatomic) NSInteger colorIdx;
@property (assign, nonatomic) id<SelectBgColorDelegate> delegate;
@property (strong, nonatomic) UISlider *slider;
- (instancetype)initWithColors:(NSArray *)colors;
@end
