//
//  DynamicScrollView.m
//  MeltaDemo
//
//  Created by hejiangshan on 14-8-27.
//  Copyright (c) 2014年 hejiangshan. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "DynamicScrollView.h"

@interface DynamicScrollView()
@property(nonatomic,retain)NSMutableArray *imageViews;
@property(nonatomic,assign)BOOL isDeleting;
@end

@implementation DynamicScrollView
{
    NSMutableArray *imageViews;
    BOOL isDeleting;
    CGPoint startPoint;
    CGPoint originPoint;
    BOOL isContain;
    UIButton *addBtn;
}

@synthesize scrollView,imageViews,isDeleting;

- (instancetype)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        imageViews = [NSMutableArray arrayWithCapacity:images.count];
        self.images = images;
        //        singleWidth = width/(images.count-1);
        //创建底部滑动视图
        [self _initScrollView];
        [self _initViews];
        isDeleting = YES;
    }
    return self;
}

- (void)_initScrollView
{
    if (scrollView == nil) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        [self addSubview:scrollView];
    }
}

- (void)_initViews
{
    NSUInteger imgcount = self.images.count;
    for (NSUInteger i = 0; i < imgcount; i++) {
        UIImage *image = _imgDataType ? self.images[i][IMAGE_SOURCE] : self.images[i];
        [self createImageViews:i withImage:image];
    }
    [self initAddImgBtn];
    self.scrollView.contentSize = CGSizeMake(ImgViewPading+(imgcount+1)*ImgViewWPading, self.scrollView.frame.size.height);
}

- (void)createImageViews:(NSInteger)i withImage:(UIImage *)image
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.frame = CGRectMake(ImgViewWPading*i+ImgViewPading, ImgViewPading, ImgViewWH, ImgViewWH);
    imgView.userInteractionEnabled = YES;
    [self.scrollView addSubview:imgView];
    [imageViews addObject:imgView];
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imgView addGestureRecognizer:tapPress];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    [imgView addGestureRecognizer:longPress];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"WDIPh_icon_tiny_x"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
//    if (isDeleting) {
//        [deleteButton setHidden:NO];
//    } else {
//        [deleteButton setHidden:YES];
//    }
    deleteButton.frame = CGRectMake(ImgViewWH-DeleteImgIconWH, 0, DeleteImgIconWH, DeleteImgIconWH);
    deleteButton.backgroundColor = [UIColor clearColor];
    [imgView addSubview:deleteButton];
}

- (void)initAddImgBtn {
    NSInteger imgcount = [_images count];
    if (imgcount < GOODS_IMG_COUNT) {
        addBtn = [[UIButton alloc] initWithFrame:CGRectMake(ImgViewPading+ImgViewWPading*imgcount, ImgViewPading, ImgViewWH, ImgViewWH)];
        [addBtn setTitle:@"+" forState:UIControlStateNormal];
        [addBtn setTitleColor:kTitleGrayColor forState:UIControlStateNormal];
        addBtn.titleLabel.font = kContentFontLarge;
        [addBtn addTarget:self action:@selector(pickImageAction) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:addBtn];
    }

}

- (void)pickImageAction {
    if (_delegate && [_delegate respondsToSelector:@selector(pickImage)]) {
        [_delegate pickImage];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    UIImageView *imageView = (UIImageView *)recognizer.view;
    NSInteger index = [imageViews indexOfObject:imageView];
    NSInteger imgCount = [imageViews count];
    if (_delegate && [_delegate respondsToSelector:@selector(tapImageAction:totalImgsCount:)]) {
        [_delegate tapImageAction:index totalImgsCount:imgCount];
    }
}

//长按调用的方法
- (void)longAction:(UILongPressGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {//长按开始
        startPoint = [recognizer locationInView:recognizer.view];
        originPoint = imageView.center;
        //isDeleting = !isDeleting;
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        }];
//        for (UIImageView *imageView in imageViews) {
//            UIButton *deleteButton = (UIButton *)imageView.subviews[0];
//            if (isDeleting) {
//                deleteButton.hidden = NO;
//            } else {
//                deleteButton.hidden = YES;
//            }
//        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {//长按移动
        CGPoint newPoint = [recognizer locationInView:recognizer.view];
        CGFloat deltaX = newPoint.x - startPoint.x;
        CGFloat deltaY = newPoint.y - startPoint.y;
        imageView.center = CGPointMake(imageView.center.x + deltaX, imageView.center.y + deltaY);
        NSInteger index = [self indexOfPoint:imageView.center withView:imageView];
        if (index < 0) {
            isContain = NO;
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                CGPoint temp = CGPointZero;
                UIImageView *currentImagView = imageViews[index];
                NSInteger idx = [imageViews indexOfObject:imageView];
                temp = currentImagView.center;
                currentImagView.center = originPoint;
                imageView.center = temp;
                originPoint = imageView.center;
                isContain = YES;
                [_images exchangeObjectAtIndex:idx withObjectAtIndex:index];
                [imageViews exchangeObjectAtIndex:idx withObjectAtIndex:index];
            } completion:^(BOOL finished) {
            }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {//长按结束
        [UIView animateWithDuration:0.3 animations:^{
            imageView.transform = CGAffineTransformIdentity;
            if (!isContain) {
                imageView.center = originPoint;
            }
        }];
    }
}

//获取view在imageViews中的位置
- (NSInteger)indexOfPoint:(CGPoint)point withView:(UIView *)view
{
    UIImageView *originImageView = (UIImageView *)view;
    for (NSInteger i = 0; i < imageViews.count; i++) {
        UIImageView *otherImageView = imageViews[i];
        if (otherImageView != originImageView) {
            if (CGRectContainsPoint(otherImageView.frame, point)) {
                return i;
            }
        }
    }
    return -1;
}

- (void)deleteAction:(UIButton *)button
{
    isDeleting = YES;   //正处于删除状态
    UIImageView *imageView = (UIImageView *)button.superview;
    NSInteger index = [imageViews indexOfObject:imageView];
    __block CGRect rect = imageView.frame;
    __weak UIScrollView *weakScroll = scrollView;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            for (NSInteger i = index + 1; i < imageViews.count; i++) {
                UIImageView *otherImageView = imageViews[i];
                CGRect originRect = otherImageView.frame;
                otherImageView.frame = rect;
                rect = originRect;
            }
        } completion:^(BOOL finished) {
            [imageViews removeObject:imageView];
            [self.images removeObjectAtIndex:index];
            [self updateAddBtnPosition:[_images count]];
            
            if (imageViews.count > ImgViewBaseShowCount) {
                weakScroll.contentSize = CGSizeMake(ImgViewWH*imageViews.count, scrollView.frame.size.height);
            }
        }];
    }];
}

//添加一个新图片
- (void)addImageView:(UIImage *)image
{
    [self createImageViews:imageViews.count withImage:image];
    [self.images addObject:image];
}

- (void)addImageViewWithDic:(NSDictionary *)imageDic {
    UIImage *image = [imageDic valueForKey:IMAGE_SOURCE];
    [self createImageViews:imageViews.count withImage:image];
    [self.images addObject:imageDic];
}

- (void)updateAddBtnPosition:(NSInteger)index {
    NSInteger imgcount = [_images count];
    if (imgcount < GOODS_IMG_COUNT) {
        CGRect tempRect = addBtn.frame;
        tempRect.origin.x = ImgViewPading+ImgViewWPading*imgcount;;
        addBtn.frame = tempRect;
        addBtn.hidden = NO;
        imgcount++;
    }else {
        addBtn.hidden = YES;
    }
    
    [imageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *imgView = (UIImageView *)obj;
        imgView.image = _imgDataType ? _images[idx][IMAGE_SOURCE] : _images[idx];
    }];
    
    CGFloat scrContentW = ImgViewPading+ImgViewWPading*imgcount;
    self.scrollView.contentSize = CGSizeMake(scrContentW, self.scrollView.frame.size.height);
    if (scrContentW > kScreenWidth) {
        if (imgcount > ImgViewBaseShowCount) {
            CGPoint scrContentOffset = self.scrollView.contentOffset;
            scrContentOffset.x = (imgcount-ImgViewBaseShowCount)*ImgViewWPading+ImgViewPading;
            [self.scrollView setContentOffset:scrContentOffset animated:YES];
        }
    }
}

@end
