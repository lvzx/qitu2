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
#import "UIImage+Handler.h"

@interface CropImageViewController ()
{
    NSArray *proportionBtnArr;
    NSArray *proportionArr;//存储不同缩放比例
    CGFloat currentProportion;//当前选择的缩放比例
    
    CGFloat destImgWidth, destImgHeight;//裁剪成功，返回的imageView的尺寸
}
@property (nonatomic, strong) PhotoTweakView *photoView;
@property (nonatomic, strong) UIButton *preSelectedBtn;

@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

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
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    currentProportion = _imgSize.width/_imgSize.height;
    NSInteger btnIndex = 0;
    for (NSInteger i = 0; i < [proportionArr count]; i++) {
        CGFloat temp = [proportionArr[i] floatValue];
        if (temp == currentProportion) {
            btnIndex = i;
            break;
        }
    }
    [self buttonTouch:proportionBtnArr[btnIndex]];
    
    NSLog(@"***image frame:%@, imageSize:%@, currentProportion:%@", NSStringFromCGSize(_orginalImage.size), NSStringFromCGSize(_imgSize), @(currentProportion));


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
    proportionArr = @[@0, @1, @(2.0/3.0), @(4.0/3.0), @(16.0/9.0)];
    proportionBtnArr = @[_btn0, _btn1, _btn2, _btn3, _btn4];
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
    CGRect cropRect = [self.photoView cropAreaInImage];
    UIImage *cropImage = [self.orginalImage imageAtRect:cropRect];
    
    NSDictionary *info = @{@"image":cropImage, @"width":@(destImgWidth), @"height":@(destImgHeight)};
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CropOK" object:info];
    }];
}

- (IBAction)buttonTouch:(UIButton *)sender {
    if (_preSelectedBtn != sender) {
        _preSelectedBtn.selected = NO;
        _preSelectedBtn = sender;
    }
    sender.selected = !sender.selected;
    
    NSInteger index = sender.tag - 10;
    [self setDestImageSizeWithIndex:index];
    currentProportion = [proportionArr[index] floatValue];
    [self.photoView updateCropProportion:currentProportion];
}

- (void)setDestImageSizeWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            destImgWidth = _imgSize.width;
            destImgHeight = _imgSize.height;
        }
            break;
        case 1:
        {
            CGFloat tempValue = MIN(_imgSize.width, _imgSize.height);
            destImgWidth = tempValue;
            destImgHeight = tempValue;
        }
            break;
        case 2:
        {
            CGFloat tempValue = MIN(_imgSize.width, _imgSize.height);
            destImgWidth = tempValue;
            destImgHeight = tempValue*3/2;
        }
            break;
        case 3:
        {
            CGFloat tempValue = MIN(_imgSize.width, _imgSize.height);
            destImgWidth = tempValue*4/3;
            destImgHeight = tempValue;
        }
            break;
        case 4:
        {
            CGFloat tempValue = MIN(_imgSize.width, _imgSize.height);
            destImgWidth = tempValue*16/9;
            destImgHeight = tempValue;
        }
            break;
        default:
            break;
    }
}
@end
