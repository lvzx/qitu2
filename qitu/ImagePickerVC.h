//
//  ImagePickerVC.h
//  qitu
//
//  Created by 上海企图 on 16/4/26.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
/*
@class ImagePickerVC;
@protocol ImagePickerVCDelegate <NSObject>

- (void)imagePickerController:(ImagePickerVC *)controller didPickImage:(UIImage *)asset;
- (void)imagePIckerControllerDidCancle:(ImagePickerVC *)controller;

@end
*/
@interface ImagePickerVC : UICollectionViewController
@property (nonatomic, strong) PHAssetCollection *assets;
@property (nonatomic, assign) CGSize imgSize;
//@property (weak, nonatomic) id<ImagePickerVCDelegate> myDelegate;
@end

@interface PHAsset (TSImagePickerHelpers)

- (NSData *)ts_imageData;

@end