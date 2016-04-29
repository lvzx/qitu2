//
//  PhotoTweakView.m
//  qitu
//
//  Created by 上海企图 on 16/4/27.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "PhotoTweakView.h"

static const int kCropCornerWidth = 19;
static const CGFloat kLeftPadding = 36;
static const CGFloat kCropViewBorderWidth = 1.0f;

@implementation PhotoContentView

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _image = image;
        
        self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = self.image;
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end

@interface PhotoScrollView : UIScrollView

@property (strong, nonatomic) PhotoContentView *photoContentView;

@end

@implementation PhotoScrollView

- (void)setContentOffsetY:(CGFloat)offsetY
{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetY;
    self.contentOffset = contentOffset;
}

- (void)setContentOffsetX:(CGFloat)offsetX
{
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x = offsetX;
    self.contentOffset = contentOffset;
}

- (CGFloat)zoomScaleToBound
{
    CGFloat scaleW = self.bounds.size.width / self.photoContentView.bounds.size.width;
    CGFloat scaleH = self.bounds.size.height / self.photoContentView.bounds.size.height;
    CGFloat max = MAX(scaleW, scaleH);
    
    return max;
}

@end

@interface CropView ()
@property (nonatomic, strong) UIImageView *upperLeft;
@property (nonatomic, strong) UIImageView *upperRight;
@property (nonatomic, strong) UIImageView *lowerLeft;
@property (nonatomic, strong) UIImageView *lowerRight;
@property (nonatomic, weak) id<CropViewDelegate> delegate;

- (void)resetCropCorner:(CGRect)frame;
@end

@implementation CropView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        _upperLeft = [[UIImageView alloc] init];
        _upperLeft.image = [UIImage imageNamed:@"maka_cut"];
        [self addSubview:_upperLeft];
        
        _upperRight = [[UIImageView alloc] init];
        _upperRight.image = [UIImage imageNamed:@"maka_cut"];
        [self addSubview:_upperRight];
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
        _upperRight.transform = transform;
        
        _lowerLeft = [[UIImageView alloc] init];
        _lowerLeft.image = [UIImage imageNamed:@"maka_cut"];
        [self addSubview:_lowerLeft];
        transform = CGAffineTransformMakeRotation(M_PI*3/2);
        _lowerLeft.transform = transform;
        
        _lowerRight = [[UIImageView alloc] init];
        _lowerRight.image = [UIImage imageNamed:@"maka_cut"];
        [self addSubview:_lowerRight];
        transform = CGAffineTransformMakeRotation(M_PI);
        _lowerRight.transform = transform;
    }
    return self;
}

- (void)resetCropCorner:(CGRect)frame {
    _upperLeft.frame = CGRectMake(0, 0, kCropCornerWidth, kCropCornerWidth);
    _upperRight.frame = CGRectMake(frame.size.width-kCropCornerWidth, 0, kCropCornerWidth, kCropCornerWidth);
    _lowerLeft.frame = CGRectMake(0, frame.size.height-kCropCornerWidth, kCropCornerWidth, kCropCornerWidth);
    _lowerRight.frame = CGRectMake(frame.size.width-kCropCornerWidth, frame.size.height-kCropCornerWidth, kCropCornerWidth, kCropCornerWidth);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(cropEnded:)]) {
        [self.delegate cropEnded:self];
    }
}

@end


@interface PhotoTweakView () <UIScrollViewDelegate>

@property (nonatomic, strong) PhotoScrollView *scrollView;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGSize originalSize;

@property (nonatomic, assign) BOOL manualZoomed;

//masks
@property (nonatomic, strong) UIView *cropMaskView;

// constants
@property (nonatomic, assign) CGSize maximumCanvasSize;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGPoint originalPoint;

@end
@implementation PhotoTweakView

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    if (self = [super init]) {
        
        self.frame = frame;
        
        _image = image;
        /*
        // scale the image
        _maximumCanvasSize = CGSizeMake(kMaximumCanvasWidthRatio * self.frame.size.width,
                                        kMaximumCanvasHeightRatio * self.frame.size.height);
        
        CGFloat scaleX = image.size.width / self.maximumCanvasSize.width;
        CGFloat scaleY = image.size.height / self.maximumCanvasSize.height;
        CGFloat scale = MAX(scaleX, scaleY);
        CGRect bounds = CGRectMake(0, 0, image.size.width / scale, image.size.height / scale);
        _originalSize = bounds.size;
        
        _centerY = CGRectGetHeight(self.frame)/2;
        */
//        CGFloat boundsW, boundsH;
//        CGFloat imgWHScale = image.size.width/image.size.height;
//        if (imgWHScale > 1.0) {
//            boundsH = kScreenWidth*0.75;
//            boundsW = imgWHScale*boundsH;
//        }else {
//            boundsW = kScreenWidth-kLeftPadding*2;
//            boundsH = boundsW/imgWHScale;
//        }
//        CGRect bounds = CGRectMake(0, 0, boundsW, boundsH);
//        
//        CGFloat cropW = kScreenWidth-kLeftPadding*2;
//        CGFloat cropY = (self.bounds.size.height-boundsH)/2;
//        CGRect cropRect = CGRectMake(kLeftPadding, cropY, cropW, boundsH);
//        
//        _originalSize = bounds.size;
        
        _scrollView = [[PhotoScrollView alloc] init];
        _scrollView.bounces = YES;
        _scrollView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = 10;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        //_scrollView.contentSize = bounds.size;
        //[_scrollView setContentOffsetX:(boundsW-cropW)/2];
        [self addSubview:_scrollView];
#ifdef kInstruction
        _scrollView.layer.borderColor = [UIColor redColor].CGColor;
        _scrollView.layer.borderWidth = 1;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
#endif
        
        _photoContentView = [[PhotoContentView alloc] initWithImage:image];
        //_photoContentView.frame = bounds;
        _photoContentView.backgroundColor = [UIColor clearColor];
        _photoContentView.userInteractionEnabled = YES;
        _scrollView.photoContentView = self.photoContentView;
        [self.scrollView addSubview:_photoContentView];
        
        _cropView = [[CropView alloc] init];
        _cropView.userInteractionEnabled = NO;
        [self addSubview:_cropView];
        
        _cropMaskView = [[UIView alloc] initWithFrame:self.bounds];
        _cropMaskView.userInteractionEnabled = NO;
        _cropMaskView.backgroundColor = [UIColor blackColor];
        _cropMaskView.alpha = 0.6;
        [self addSubview:_cropMaskView];
        
        self.clipsToBounds = YES;
    }
    return self;
}
/**
 *根据当前裁剪区域的位置和尺寸将黑色蒙板的相应区域抠成透明
 */
- (void)resetCropMask {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect: self.cropMaskView.bounds];
    UIBezierPath *clearPath = [[UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(self.cropView.frame) + kCropViewBorderWidth, CGRectGetMinY(self.cropView.frame) + kCropViewBorderWidth, CGRectGetWidth(self.cropView.frame) - 2 * kCropViewBorderWidth, CGRectGetHeight(self.cropView.frame) - 2 * kCropViewBorderWidth)] bezierPathByReversingPath];
    [path appendPath: clearPath];
    
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.cropMaskView.layer.mask;
    if(!shapeLayer) {
        shapeLayer = [CAShapeLayer layer];
        [self.cropMaskView.layer setMask: shapeLayer];
    }
    shapeLayer.path = path.CGPath;
}

- (void)setNormalCropSize:(CGSize)normalCropSize {
    CGFloat boundsW, boundsH;
    _maximumCanvasSize = CGSizeMake(kScreenWidth*0.75, self.frame.size.height-2*kLeftPadding);
    CGFloat imgWHScale = _image.size.width/_image.size.height;
    if (imgWHScale > 1.0) {
        boundsH = _maximumCanvasSize.height;
        boundsW = imgWHScale*boundsH;
    }else {
        boundsW = _maximumCanvasSize.width;
        boundsH = boundsW/imgWHScale;
    }
    CGRect bounds = CGRectMake(0, 0, boundsW, boundsH);
    
    CGFloat cropX, cropY, cropW, cropH, normalWHScale;
    normalWHScale = normalCropSize.width/normalCropSize.height;
    if (normalWHScale > 1) {
        cropW = MIN(_maximumCanvasSize.width, boundsW);
        cropH = cropW/normalWHScale;
    }else {
        cropH = MIN(_maximumCanvasSize.height, boundsH);
        cropW = cropH*normalWHScale;
    }
    cropX = (self.bounds.size.width-cropW)/2;
    cropY = (self.bounds.size.height-cropH)/2;
    
    CGRect cropRect = CGRectMake(cropX, cropY, cropW, cropH);
    
    _originalSize = bounds.size;
    
    self.scrollView.frame = cropRect;
    self.scrollView.contentSize = bounds.size;
     _scrollView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame)/2);
    [_scrollView setContentOffsetX:(boundsW-cropW)/2];
    
    self.photoContentView.frame = bounds;
    
    self.cropView.frame = cropRect;
    _cropView.center = self.scrollView.center;
    [_cropView resetCropCorner:cropRect];
    
    [self resetCropMask];
    
     _originalPoint = [self convertPoint:self.scrollView.center toView:self];
    NSLog(@"$$$bounds:%@, cropRect:%@", NSStringFromCGRect(bounds), NSStringFromCGRect(cropRect));
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.photoContentView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    self.manualZoomed = YES;
}

/*
#pragma mark - Crop View Delegate

- (void)cropEnded:(CropView *)cropView
{
    CGFloat scaleX = self.originalSize.width / cropView.bounds.size.width;
    CGFloat scaleY = self.originalSize.height / cropView.bounds.size.height;
    CGFloat scale = MIN(scaleX, scaleY);
    
    // calculate the new bounds of crop view
    CGRect newCropBounds = CGRectMake(0, 0, scale * cropView.frame.size.width, scale * cropView.frame.size.height);
    
    // calculate the new bounds of scroll view
    CGFloat width = newCropBounds.size.width;
    CGFloat height = newCropBounds.size.height;
    
    // calculate the zoom area of scroll view
    CGRect scaleFrame = cropView.frame;
    if (scaleFrame.size.width >= self.scrollView.bounds.size.width) {
        scaleFrame.size.width = self.scrollView.bounds.size.width - 1;
    }
    if (scaleFrame.size.height >= self.scrollView.bounds.size.height) {
        scaleFrame.size.height = self.scrollView.bounds.size.height - 1;
    }
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGPoint contentOffsetCenter = CGPointMake(contentOffset.x + self.scrollView.bounds.size.width / 2, contentOffset.y + self.scrollView.bounds.size.height / 2);
    CGRect bounds = self.scrollView.bounds;
    bounds.size.width = width;
    bounds.size.height = height;
    self.scrollView.bounds = CGRectMake(0, 0, width, height);
    CGPoint newContentOffset = CGPointMake(contentOffsetCenter.x - self.scrollView.bounds.size.width / 2, contentOffsetCenter.y - self.scrollView.bounds.size.height / 2);
    self.scrollView.contentOffset = newContentOffset;
    
    [UIView animateWithDuration:0.25 animations:^{
        // animate crop view
        cropView.bounds = CGRectMake(0, 0, newCropBounds.size.width, newCropBounds.size.height);
        cropView.center = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
        
        // zoom the specified area of scroll view
        CGRect zoomRect = [self convertRect:scaleFrame toView:self.scrollView.photoContentView];
        [self.scrollView zoomToRect:zoomRect animated:NO];
    }];
    
    self.manualZoomed = YES;
    
    CGFloat scaleH = self.scrollView.bounds.size.height / self.scrollView.contentSize.height;
    CGFloat scaleW = self.scrollView.bounds.size.width / self.scrollView.contentSize.width;
    __block CGFloat scaleM = MAX(scaleH, scaleW);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (scaleM > 1) {
            scaleM = scaleM * self.scrollView.zoomScale;
            [self.scrollView setZoomScale:scaleM animated:NO];
        }
        [UIView animateWithDuration:0.2 animations:^{
            [self checkScrollViewContentOffset];
        }];
    });
}

- (void)checkScrollViewContentOffset
{
    self.scrollView.contentOffsetX = MAX(self.scrollView.contentOffset.x, 0);
    self.scrollView.contentOffsetY = MAX(self.scrollView.contentOffset.y, 0);
    
    if (self.scrollView.contentSize.height - self.scrollView.contentOffset.y <= self.scrollView.bounds.size.height) {
        self.scrollView.contentOffsetY = self.scrollView.contentSize.height - self.scrollView.bounds.size.height;
    }
    
    if (self.scrollView.contentSize.width - self.scrollView.contentOffset.x <= self.scrollView.bounds.size.width) {
        self.scrollView.contentOffsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    }
}
*/
- (CGPoint)photoTranslation
{
    CGRect rect = [self.photoContentView convertRect:self.photoContentView.bounds toView:self];
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    CGPoint zeroPoint = CGPointMake(CGRectGetWidth(self.frame) / 2, self.centerY);
    return CGPointMake(point.x - zeroPoint.x, point.y - zeroPoint.y);
}

@end
