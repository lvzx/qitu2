//
//  DiyPageSortBottomBar.h
//  qitu
//
//  Created by 上海企图 on 16/5/4.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ImgViewW 72
#define ImgViewH 116
#define ImgViewPading 12
#define ImgViewWPading 85
#define DeleteImgIconWH 25
#define ImgViewBaseShowCount 4
#define GOODS_IMG_COUNT 11

#define IMAGE_SOURCE    @"imagesource"
#define IMAGE_DESC  @"imagedesc"

@protocol DiyPageSortDelegate;

@interface DiyPageSortBottomBar : UIView

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)NSMutableArray *images;
@property (nonatomic) NSInteger imgDataType;//0 UIImage, 1 Dic
@property (nonatomic, assign) id<DiyPageSortDelegate> delegate;

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

@protocol DiyPageSortDelegate <NSObject>
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
- (void)tapImageAction:(NSInteger)index;

@end

