//
//  PhotoTweakView.h
//  qitu
//
//  Created by 上海企图 on 16/4/27.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CropView;

@interface PhotoContentView : UIView

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@end

@protocol CropViewDelegate <NSObject>

- (void)cropEnded:(CropView *)cropView;

@end

@interface CropView : UIView
@end

@interface PhotoTweakView : UIView

@property (assign, nonatomic) CGFloat angle;
@property (strong, nonatomic) PhotoContentView *photoContentView;
@property (assign, nonatomic) CGPoint photoContentOffset;
@property (strong, nonatomic) CropView *cropView;
@property (assign, nonatomic) CGSize normalCropSize;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (CGPoint)photoTranslation;
/**
 *根据当前裁剪区域的位置和尺寸将黑色蒙板的相应区域抠成透明
 */
- (void)resetCropMask;
@end
