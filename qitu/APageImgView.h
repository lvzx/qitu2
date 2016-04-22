//
//  APageImgView.h
//  qitu
//
//  Created by 上海企图 on 16/4/21.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DiyShowDelgate <NSObject>
- (void)showImgBottomView;
- (void)showTextBottomView;
@end

@interface APageImgView : UIView
@property (nonatomic, assign) BOOL hasBorder;
@property (nonatomic, strong) UIImage *image;
@property (assign, nonatomic) id<DiyShowDelgate> myDelegate;
@end
