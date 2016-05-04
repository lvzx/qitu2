//
//  DiyMainBottomBar.h
//  qitu
//
//  Created by 上海企图 on 16/4/5.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiyMainBottomBar
- (void)diySelectDiyMainBarBtn:(UIButton *)btn;//btn.tag 由 30 开始自增
@end

@interface DiyMainBottomBar : UIView
@property (assign, nonatomic) NSInteger pageNum;//页面显示数字
- (instancetype)initWithFrame:(CGRect)frame actionHandler:(id)target;

@end

