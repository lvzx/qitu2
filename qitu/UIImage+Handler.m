//
//  UIImage+Handler.m
//  qitu
//
//  Created by 上海企图 on 16/4/29.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "UIImage+Handler.h"

@implementation UIImage (Handler)
- (UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}
@end
