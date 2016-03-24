//
//  MyUtills.m
//  qitu
//
//  Created by 上海企图 on 16/3/24.
//  Copyright © 2016年 上海企图. All rights reserved.
//

#import "MyUtills.h"

@implementation MyUtills
#pragma mark - Common Function
+ (void)setViewBorder:(UIView *)aView {
    aView.layer.borderColor = VIEW_BORDERCOLOR.CGColor;
    aView.layer.borderWidth = 1.0f;
}

+ (void)setViewBorderAndCorner:(UIView *)aView {
    aView.layer.borderColor = VIEW_BORDERCOLOR.CGColor;
    aView.layer.borderWidth = 1.0f;
    aView.layer.cornerRadius = 3.0f;
}

+ (void)roundedView:(UIView *)aView {
    [self setViewBorder:aView];
    CGSize aViewSize = aView.frame.size;
    aView.layer.cornerRadius = aViewSize.height / 2.0;
    aView.layer.masksToBounds = YES;
}

+ (void)addDoneToKeyboardWith:(UIView *)activeView Handler:(id)obj withResignAction:(SEL)selector {
    //定义完成按钮
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [topView setTintColor:[UIColor whiteColor]];
    [topView setBarStyle:UIBarStyleBlack];
    
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:obj action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:obj action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:obj action:selector];
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    
    [topView setItems:buttonsArray];
    
    if([activeView isKindOfClass:[UITextField class]])
    {
        UITextField * text = (UITextField *)activeView;
        
        [text setInputAccessoryView:topView];
        
    }
    else
    {
        UITextView * textView = (UITextView *)activeView;
        
        [textView setInputAccessoryView:topView];
    }
}

+ (CGSize)boundingRectText:(NSString *)str WithFont:(UIFont *)font WithSize:(CGSize)size
{
    if (!font) {
        font = [UIFont systemFontOfSize:15.0];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [str boundingRectWithSize:size
                                       options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil].size;
    
    return retSize;
}

+ (void) showImagePicker:(id)delegate view:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>*)controller
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = controller;
    [controller presentViewController:picker animated:YES completion:nil];
}

+ (void) showCamera:(id)delegate view:(UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>*) controller allowsEditing:(BOOL)allow
{
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = controller;
    picker.allowsEditing = allow;
    picker.sourceType = sourceType;
    [controller presentViewController:picker animated:YES completion:nil];
}

+ (UIImage *) changeImageOrientation:(UIImage *)image
{
    UIImageOrientation imageOrientation=image.imageOrientation;
    
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    return image;
}

+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

#pragma mark  Common utilities

+(NSString *)getDeviceTokenFromData:(NSData *)deviceToken
{
    
    //获取APNS设备令牌
    NSMutableString * deviceTokenStr = [NSMutableString stringWithFormat:@"%@",deviceToken];
    NSRange allRang;
    allRang.location    = 0;
    allRang.length      = deviceTokenStr.length;
    
    [deviceTokenStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:allRang];
    
    NSRange begin   = [deviceTokenStr rangeOfString:@"<"];
    NSRange end     = [deviceTokenStr rangeOfString:@">"];
    
    NSRange deviceRange;
    deviceRange.location    = begin.location + 1;
    deviceRange.length      = end.location - begin.location -1;
    
    return [deviceTokenStr substringWithRange:deviceRange];
}

+(void)showAppCommentWithAppID:(int)appID
{
    //显示AppStore应用评论
    NSString *appCommentUrlStr = [NSString stringWithFormat:kAPPCommentUrl, appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appCommentUrlStr]];
}

+ (void)call:(NSString *)telephoneNum
{
    NSString *str = [NSString stringWithFormat:@"tel://%@", telephoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)sendSMS:(NSString *)telephoneNum
{
    NSString *str = [NSString stringWithFormat:@"sms://%@", telephoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)sendEmail:(NSString *)emailAddr
{
    NSString *str = [NSString stringWithFormat:@"mailto://%@", emailAddr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)openUrl:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+(NSStringEncoding)getGBKEncoding
{
    //获得中文gbk编码
    return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

@end
