//
//  DynamicScrollView.h
//  MeltaDemo
//
//  Created by hejiangshan on 14-8-27.
//  Copyright (c) 2014年 hejiangshan. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

#define ImgViewWH 65
#define ImgViewPading 8
#define ImgViewWPading 73
#define DeleteImgIconWH 16
#define ImgViewBaseShowCount 4
#define GOODS_IMG_COUNT 15

#define IMAGE_SOURCE    @"imagesource"
#define IMAGE_DESC  @"imagedesc"

@protocol MSUpdateAddBtnPositionDelegate;
@interface DynamicScrollView : UIView

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

@property(nonatomic,retain)UIScrollView *scrollView;

@property(nonatomic,retain)NSMutableArray *images;

@property (nonatomic) NSInteger imgDataType;//0 UIImage, 1 Dic

@property (nonatomic, assign) id<MSUpdateAddBtnPositionDelegate> delegate;

/**
 *  添加一个imageView
 *
 *  @param imageDic 字典结构参数（图片＋标题）
 */
- (void)addImageViewWithDic:(NSDictionary *)imageDic;

/**
 *  添加一个imageView
 *
 *  @param image 图片
 */
- (void)addImageView:(UIImage *)image;

/**
 *  更新新增图片按钮的位置
 *
 *  @param index 索引即为图片数组的长度（图片末尾）
 */
- (void)updateAddBtnPosition:(NSInteger)index;

@end

@protocol MSUpdateAddBtnPositionDelegate <NSObject>
/**
 *  单击新增图片按钮选择图片方法
 */
- (void)pickImage;
@optional
/**
 *  点击图片所触发的方法
 *
 *  @param index      所点击图片的索引值
 *  @param totalCount 图片数组长度（图片总数）
 */
- (void)tapImageAction:(NSInteger)index totalImgsCount:(NSInteger)totalCount;

@end
