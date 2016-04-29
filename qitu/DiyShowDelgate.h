//
//  DiyShowDelgate.h
//  qitu
//
//  Created by 上海企图 on 16/4/22.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DiyShowDelgate <NSObject>
- (void)showImgBottomView:(UIView *)element;
- (void)showTextBottomView:(UIView *)element;

@optional
- (void)addPage;
- (void)addForm;
@end
