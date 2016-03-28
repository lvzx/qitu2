//
//  QTBuyMainView.h
//  qitu
//
//  Created by 上海企图 on 16/3/28.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTBuyMainView : UIView

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;

@property(nonatomic, copy)NSString *title;

- (void)reloadData;

@end
