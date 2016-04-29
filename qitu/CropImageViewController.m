//
//  CropImageViewController.m
//  qitu
//
//  Created by 上海企图 on 16/4/25.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "CropImageViewController.h"
#import "PhotoTweakView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CropImageViewController ()
@property (nonatomic, strong) PhotoTweakView *photoView;
@property (nonatomic, strong) UIButton *preSelectedBtn;
@end

@implementation CropImageViewController

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        _orginalImage = image;
        _autoSaveToLibray = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpNav];
    [self setupSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpNav {
    [self setNavTitle:@"裁剪"];
    [self setNavBackBarSelector:@selector(navBack)];
    [self setNavRightBarBtnTitle:@"确定" selector:@selector(doneCrop)];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupSubviews {
    CGRect photoRect = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-70);
    self.photoView = [[PhotoTweakView alloc] initWithFrame:photoRect image:_orginalImage];
    self.photoView.normalCropSize = _imgSize;
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.photoView];
}

- (void)navBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneCrop {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // translate
    CGPoint translation = [self.photoView photoTranslation];
    transform = CGAffineTransformTranslate(transform, translation.x, translation.y);
    
    // rotate
    transform = CGAffineTransformRotate(transform, self.photoView.angle);
    
    // scale
    CGAffineTransform t = self.photoView.photoContentView.transform;
    CGFloat xScale =  sqrt(t.a * t.a + t.c * t.c);
    CGFloat yScale = sqrt(t.b * t.b + t.d * t.d);
    transform = CGAffineTransformScale(transform, xScale, yScale);
    
    CGImageRef imageRef = [self newTransformedImage:transform
                                        sourceImage:self.orginalImage.CGImage
                                         sourceSize:self.orginalImage.size
                                  sourceOrientation:self.orginalImage.imageOrientation
                                        outputWidth:self.orginalImage.size.width
                                           cropSize:self.photoView.cropView.frame.size
                                      imageViewSize:self.photoView.photoContentView.bounds.size];
    
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    if (self.autoSaveToLibray) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
            }
        }];
    }
    
    [self.delegate cropImageViewController:self didFinishWithCropedImage:image];

}
- (CGImageRef)newScaledImage:(CGImageRef)source withOrientation:(UIImageOrientation)orientation toSize:(CGSize)size withQuality:(CGInterpolationQuality)quality
{
    CGSize srcSize = size;
    CGFloat rotation = 0.0;
    
    switch(orientation)
    {
        case UIImageOrientationUp: {
            rotation = 0;
        } break;
        case UIImageOrientationDown: {
            rotation = M_PI;
        } break;
        case UIImageOrientationLeft:{
            rotation = M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        case UIImageOrientationRight: {
            rotation = -M_PI_2;
            srcSize = CGSizeMake(size.height, size.width);
        } break;
        default:
            break;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 size.width,
                                                 size.height,
                                                 8,  //CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst  //CGImageGetBitmapInfo(source)
                                                 );
    
    CGContextSetInterpolationQuality(context, quality);
    CGContextTranslateCTM(context,  size.width/2,  size.height/2);
    CGContextRotateCTM(context,rotation);
    
    CGContextDrawImage(context, CGRectMake(-srcSize.width/2 ,
                                           -srcSize.height/2,
                                           srcSize.width,
                                           srcSize.height),
                       source);
    
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    return resultRef;
}

- (CGImageRef)newTransformedImage:(CGAffineTransform)transform
                      sourceImage:(CGImageRef)sourceImage
                       sourceSize:(CGSize)sourceSize
                sourceOrientation:(UIImageOrientation)sourceOrientation
                      outputWidth:(CGFloat)outputWidth
                         cropSize:(CGSize)cropSize
                    imageViewSize:(CGSize)imageViewSize
{
    CGImageRef source = [self newScaledImage:sourceImage
                             withOrientation:sourceOrientation
                                      toSize:sourceSize
                                 withQuality:kCGInterpolationNone];
    
    CGFloat aspect = cropSize.height/cropSize.width;
    CGSize outputSize = CGSizeMake(outputWidth, outputWidth*aspect);
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 outputSize.width,
                                                 outputSize.height,
                                                 CGImageGetBitsPerComponent(source),
                                                 0,
                                                 CGImageGetColorSpace(source),
                                                 CGImageGetBitmapInfo(source));
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, outputSize.width, outputSize.height));
    
    CGAffineTransform uiCoords = CGAffineTransformMakeScale(outputSize.width / cropSize.width,
                                                            outputSize.height / cropSize.height);
    uiCoords = CGAffineTransformTranslate(uiCoords, cropSize.width/2.0, cropSize.height / 2.0);
    uiCoords = CGAffineTransformScale(uiCoords, 1.0, -1.0);
    CGContextConcatCTM(context, uiCoords);
    
    CGContextConcatCTM(context, transform);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(-imageViewSize.width/2.0,
                                           -imageViewSize.height/2.0,
                                           imageViewSize.width,
                                           imageViewSize.height)
                       , source);
    
    CGImageRef resultRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGImageRelease(source);
    return resultRef;
}

- (IBAction)buttonTouch:(UIButton *)sender {
    if (_preSelectedBtn != sender) {
        _preSelectedBtn.selected = NO;
        _preSelectedBtn = sender;
    }
    NSLog(@"&&&UIButton:%@", sender);
    sender.selected = !sender.selected;
    
    NSInteger index = sender.tag - 10;
    
}

@end
