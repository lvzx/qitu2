//
//  CreatorComponentsDelegate.h
//  qitu
//
//  Created by 上海企图 on 16/4/1.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CreatorComponentsDelegate <NSObject>
#pragma - mark 选择背景色或背景图
- (void)didSelectBgColor:(UIColor *)color;
- (void)didSelectbgImage:(UIImage *)img;

- (void)didChangeAlpha:(float)value;
@end
