//
//  CropImageViewController.h
//  qitu
//
//  Created by 上海企图 on 16/4/25.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol CropImageViewControllerDelegate;

@interface CropImageViewController : BaseViewController
/**
 Image to process.
 */
@property (strong, nonatomic) UIImage *orginalImage;
/**
 *  selected imageview frame size
 */
@property (nonatomic, assign) CGSize imgSize;
/**
 Flag indicating whether the image cropped will be saved to photo library automatically. Defaults to YES.
 */
@property (nonatomic, assign) BOOL autoSaveToLibray;
/**
 The optional CropImageViewControllerDelegate.
 */
@property (nonatomic, weak) id<CropImageViewControllerDelegate> delegate;
/**
 Creates a CropImageViewController with the image to process.
 */
- (instancetype)initWithImage:(UIImage *)image;

@end

@protocol CropImageViewControllerDelegate <NSObject>

- (void)cropImageViewController:(CropImageViewController *)ctrl didFinishWithCropedImage:(UIImage *)image;
- (void)cropImageViewControllerDidCancle:(CropImageViewController *)ctrl;
@end